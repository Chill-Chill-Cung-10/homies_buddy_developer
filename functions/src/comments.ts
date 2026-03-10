import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {db} from "./config";

/**
 * Cloud Function: onCreateComment
 *
 * Trigger: onCreate posts/{postId}/comments/{commentId}
 *
 * Actions:
 * - +1 commentCount của post
 * - Tạo notification cho post author
 */
export const onCreateComment = onDocumentCreated(
  {
    document: "posts/{postId}/comments/{commentId}",
    region: "asia-southeast1",
  },
  async (event) => {
    const postId = event.params.postId;
    const commentData = event.data?.data();
    if (!commentData) return;
    const commentAuthorId = commentData.authorId;

    try {
      // +1 commentCount
      await db.collection("posts").doc(postId).update({
        commentCount: admin.firestore.FieldValue.increment(1),
      });

      // Get post author
      const postDoc = await db.collection("posts").doc(postId).get();
      const postData = postDoc.data();
      if (!postData) return;

      const postAuthorId = postData.authorId;

      // Không tạo notification nếu tự comment post của mình
      if (postAuthorId === commentAuthorId) return;

      // Tạo notification
      await db
        .collection("users")
        .doc(postAuthorId)
        .collection("notifications")
        .add({
          type: "comment",
          actorId: commentAuthorId,
          actorName: commentData.authorName || "Unknown",
          actorAvatar: commentData.authorAvatar || "",
          postId: postId,
          commentId: event.params.commentId,
          contentPreview: commentData.contentText?.substring(0, 50) || "",
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      console.log(`Created comment notification for user ${postAuthorId}`);
    } catch (error) {
      console.error("Error in onCreateComment:", error);
    }
  }
);

/**
 * Cloud Function: onDeleteComment
 *
 * Trigger: onDelete posts/{postId}/comments/{commentId}
 *
 * Actions:
 * - -1 commentCount của post
 */
export const onDeleteComment = onDocumentDeleted(
  {
    document: "posts/{postId}/comments/{commentId}",
    region: "asia-southeast1",
  },
  async (event) => {
    const postId = event.params.postId;

    try {
      await db.collection("posts").doc(postId).update({
        commentCount: admin.firestore.FieldValue.increment(-1),
      });

      console.log(`Decremented commentCount for post ${postId}`);
    } catch (error) {
      console.error("Error in onDeleteComment:", error);
    }
  }
);
