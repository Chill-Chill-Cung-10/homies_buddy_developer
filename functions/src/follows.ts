import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {db} from "./config";

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
  {
    document: "users/{userId}/following/{targetId}",
    region: "asia-southeast1",
  },
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
  }
);

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
  {
    document: "users/{userId}/following/{targetId}",
    region: "asia-southeast1",
  },
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
  }
);
