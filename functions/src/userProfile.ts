import * as admin from "firebase-admin";
import {onDocumentUpdated} from "firebase-functions/v2/firestore";
import {db} from "./config";

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
  {
    document: "users/{userId}",
    region: "asia-southeast1",
  },
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
      postsSnapshot.docs.forEach(
        (doc: admin.firestore.QueryDocumentSnapshot) => {
          batch.update(doc.ref, {
            authorName: afterData.fullName,
            authorAvatar: afterData.avatarUrl,
          });
        }
      );

      await batch.commit();

      console.log(`Updated ${postsSnapshot.size} posts for user ${userId}`);
    } catch (error) {
      console.error("Error in onUpdateUserProfile:", error);
    }
  }
);
