import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const onEmergencyTriggered = functions.firestore
  .document("emergencies/{emergencyId}")
  .onCreate(async (snap, context) => {
    const emergencyData = snap.data();
    const db = admin.firestore();

    // Broadcast notification to active users within radius
    const usersSnap = await db.collection("users").limit(50).get();
    const batch = db.batch();

    usersSnap.forEach((userDoc) => {
      if (userDoc.id !== emergencyData.userId) {
        const notifRef = db.collection("notifications").doc();
        batch.set(notifRef, {
          userId: userDoc.id,
          title: "🚨 Emergency Alert Nearby!",
          body: `Emergency Alert: ${emergencyData.type.toUpperCase()} reported nearby. Tap to view or offer help.`,
          type: "emergencyNearby",
          relatedId: context.params.emergencyId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          isRead: false,
        });
      }
    });

    await batch.commit();
  });
