import * as admin from "firebase-admin";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {db} from "./config";

/**
 * Helper: Get notification title dựa trên type
 */
export function getNotificationTitle(
  type: string,
  actorName: string
): string {
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
  {
    document: "users/{userId}/notifications/{notifId}",
    region: "asia-southeast1",
  },
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
  }
);
