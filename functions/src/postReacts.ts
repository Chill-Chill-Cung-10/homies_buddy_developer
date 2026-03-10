import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {db} from "./config";

/**
 * Cloud Function: onReactPost
 *
 * Trigger: onCreate posts/{postId}/reacts/{userId}
 *
 * Actions:
 * - +1 reactsCount của post
 * - Tạo notification cho post author (nếu không phải chính mình)
 */
export const onReactPost = onDocumentCreated(
  {
    document: "posts/{postId}/reacts/{userId}",
    region: "asia-southeast1",
  },
  async (event) => {
    const postId = event.params.postId;
    const userId = event.params.userId;

    try {
      // +1 reactsCount
      await db.collection("posts").doc(postId).update({
        reactsCount: admin.firestore.FieldValue.increment(1),
      });

      // Get post author
      const postDoc = await db.collection("posts").doc(postId).get();
      const postData = postDoc.data();
      if (!postData) return;

      const authorId = postData.authorId;

      // Không tạo notification nếu tự react post của mình
      if (authorId === userId) return;

      // Get user info (người react)
      const userDoc = await db.collection("users").doc(userId).get();
      const userData = userDoc.data();
      if (!userData) return;

      // Tạo notification
      await db
        .collection("users")
        .doc(authorId)
        .collection("notifications")
        .add({
          type: "react",
          actorId: userId,
          actorName: userData.fullName || "Unknown",
          actorAvatar: userData.avatarUrl || "",
          postId: postId,
          contentPreview: postData.contentText?.substring(0, 50) || "",
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      console.log(`Created notification for user ${authorId}`);
    } catch (error) {
      console.error("Error in onReactPost:", error);
    }
  }
);

/**
 * Cloud Function: onUnreactPost
 *
 * Trigger: onDelete posts/{postId}/reacts/{userId}
 *
 * Actions:
 * - -1 reactsCount của post
 */
export const onUnreactPost = onDocumentDeleted(
  {
    document: "posts/{postId}/reacts/{userId}",
    region: "asia-southeast1",
  },
  async (event) => {
    const postId = event.params.postId;

    try {
      await db.collection("posts").doc(postId).update({
        reactsCount: admin.firestore.FieldValue.increment(-1),
      });

      console.log(`Decremented reactsCount for post ${postId}`);
    } catch (error) {
      console.error("Error in onUnreactPost:", error);
    }
  }
);
