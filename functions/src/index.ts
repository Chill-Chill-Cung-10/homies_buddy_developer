import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentDeleted,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";

admin.initializeApp();
const db = admin.firestore();

// =============================================================================
// POST REACT FUNCTIONS
// =============================================================================

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
  "posts/{postId}/reacts/{userId}",
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
  });

/**
 * Cloud Function: onUnreactPost
 * 
 * Trigger: onDelete posts/{postId}/reacts/{userId}
 * 
 * Actions:
 * - -1 reactsCount của post
 */
export const onUnreactPost = onDocumentDeleted(
  "posts/{postId}/reacts/{userId}",
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
  });

// =============================================================================
// COMMENT FUNCTIONS
// =============================================================================

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
  "posts/{postId}/comments/{commentId}",
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
  });

/**
 * Cloud Function: onDeleteComment
 * 
 * Trigger: onDelete posts/{postId}/comments/{commentId}
 * 
 * Actions:
 * - -1 commentCount của post
 */
export const onDeleteComment = onDocumentDeleted(
  "posts/{postId}/comments/{commentId}",
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
  });

// =============================================================================
// FOLLOW FUNCTIONS
// =============================================================================

/**
 * Cloud Function: onFollowUser
 * 
 * Trigger: onCreate users/{userId}/following/{targetId}
 * 
 * Actions:
 * - +1 followingCount của user
 * - +1 followerCount của target
 * - Tạo notification cho target user
 */
export const onFollowUser = onDocumentCreated(
  "users/{userId}/following/{targetId}",
  async (event) => {
    const userId = event.params.userId;
    const targetId = event.params.targetId;

    try {
      // +1 followingCount của user
      await db.collection("users").doc(userId).update({
        followingCount: admin.firestore.FieldValue.increment(1),
      });

      // +1 followerCount của target
      await db.collection("users").doc(targetId).update({
        followerCount: admin.firestore.FieldValue.increment(1),
      });

      // Get user info (người follow)
      const userDoc = await db.collection("users").doc(userId).get();
      const userData = userDoc.data();
      if (!userData) return;

      // Tạo notification cho target
      await db
        .collection("users")
        .doc(targetId)
        .collection("notifications")
        .add({
          type: "follow",
          actorId: userId,
          actorName: userData.fullName || "Unknown",
          actorAvatar: userData.avatarUrl || "",
          contentPreview: `${userData.fullName} started following you`,
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      console.log(`User ${userId} followed ${targetId}`);
    } catch (error) {
      console.error("Error in onFollowUser:", error);
    }
  });

/**
 * Cloud Function: onUnfollowUser
 * 
 * Trigger: onDelete users/{userId}/following/{targetId}
 * 
 * Actions:
 * - -1 followingCount của user
 * - -1 followerCount của target
 */
export const onUnfollowUser = onDocumentDeleted(
  "users/{userId}/following/{targetId}",
  async (event) => {
    const userId = event.params.userId;
    const targetId = event.params.targetId;

    try {
      // -1 followingCount của user
      await db.collection("users").doc(userId).update({
        followingCount: admin.firestore.FieldValue.increment(-1),
      });

      // -1 followerCount của target
      await db.collection("users").doc(targetId).update({
        followerCount: admin.firestore.FieldValue.increment(-1),
      });

      console.log(`User ${userId} unfollowed ${targetId}`);
    } catch (error) {
      console.error("Error in onUnfollowUser:", error);
    }
  });

// =============================================================================
// PROFILE UPDATE FUNCTION
// =============================================================================

/**
 * Cloud Function: onUpdateUserProfile
 * 
 * Trigger: onUpdate users/{userId}
 * 
 * Actions:
 * - Cập nhật denormalized author info trong recent posts (last 50)
 * 
 * NOTE: Để tránh quá tốn kém, chỉ update 50 posts gần nhất.
 * Các posts cũ hơn sẽ có thông tin outdated (trade-off chấp nhận được).
 */
export const onUpdateUserProfile = onDocumentUpdated(
  "users/{userId}",
  async (event) => {
    const userId = event.params.userId;
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    if (!beforeData || !afterData) return;

    // Chỉ update nếu fullName hoặc avatarUrl thay đổi
    if (
      beforeData.fullName === afterData.fullName &&
      beforeData.avatarUrl === afterData.avatarUrl
    ) {
      return;
    }

    try {
      // Get 50 posts gần nhất của user
      const postsSnapshot = await db
        .collection("posts")
        .where("authorId", "==", userId)
        .orderBy("createdAt", "desc")
        .limit(50)
        .get();

      // Batch update
      const batch = db.batch();
      postsSnapshot.docs.forEach((doc: admin.firestore.QueryDocumentSnapshot) => {
        batch.update(doc.ref, {
          authorName: afterData.fullName,
          authorAvatar: afterData.avatarUrl,
        });
      });

      await batch.commit();

      console.log(
        `Updated ${postsSnapshot.size} posts for user ${userId}`
      );
    } catch (error) {
      console.error("Error in onUpdateUserProfile:", error);
    }
  });

// =============================================================================
// PUSH NOTIFICATION FUNCTION (Optional - nếu dùng FCM)
// =============================================================================

/**
 * Cloud Function: sendPushNotification
 * 
 * Trigger: onCreate users/{userId}/notifications/{notifId}
 * 
 * Actions:
 * - Gửi FCM push notification tới device của user
 * 
 * NOTE: Requires FCM token được lưu trong user document.
 * TODO: Implement sau khi setup FCM trong app.
 */
export const sendPushNotification = onDocumentCreated(
  "users/{userId}/notifications/{notifId}",
  async (event) => {
    const userId = event.params.userId;
    const notifData = event.data?.data();
    if (!notifData) return;

    try {
      // Get user's FCM token
      const userDoc = await db.collection("users").doc(userId).get();
      const userData = userDoc.data();
      const fcmToken = userData?.fcmToken;

      if (!fcmToken) {
        console.log(`No FCM token for user ${userId}`);
        return;
      }

      // Prepare notification payload
      const payload = {
        notification: {
          title: getNotificationTitle(notifData.type, notifData.actorName),
          body: notifData.contentPreview || "",
          // icon: notifData.actorAvatar,
        },
        data: {
          type: notifData.type,
          postId: notifData.postId || "",
          commentId: notifData.commentId || "",
        },
        token: fcmToken,
      };

      // Send push notification
      await admin.messaging().send(payload);

      console.log(`Sent push notification to user ${userId}`);
    } catch (error) {
      console.error("Error in sendPushNotification:", error);
    }
  });

/**
 * Helper: Get notification title dựa trên type
 */
function getNotificationTitle(type: string, actorName: string): string {
  switch (type) {
  case "react":
    return `${actorName} reacted to your post`;
  case "comment":
    return `${actorName} commented on your post`;
  case "follow":
    return `${actorName} started following you`;
  case "mention":
    return `${actorName} mentioned you`;
  default:
    return "New notification";
  }
}
