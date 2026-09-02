import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const sendPushNotification = functions.firestore
  .document("notifications/{notificationId}")
  .onCreate(async (snap) => {
    const notif = snap.data();
    const db = admin.firestore();

    const userDoc = await db.collection("users").doc(notif.userId).get();
    const fcmToken = userDoc.data()?.fcmToken;

    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: notif.title,
          body: notif.body,
        },
        data: {
          type: notif.type,
          relatedId: notif.relatedId || "",
        },
      });
    }
  });
