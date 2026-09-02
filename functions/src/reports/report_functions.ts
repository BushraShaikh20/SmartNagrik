import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const onReportCreated = functions.firestore
  .document("reports/{reportId}")
  .onCreate(async (snap, context) => {
    const reportData = snap.data();
    const db = admin.firestore();

    // Create initial timeline event
    await snap.ref.collection("timeline").add({
      stage: "submitted",
      title: "Report Submitted",
      description: "Civic issue submitted successfully by citizen.",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      isCompleted: true,
    });

    // Notify municipal authorities
    const authoritiesSnap = await db.collection("users").where("role", "==", "authority").get();
    const batch = db.batch();
    
    authoritiesSnap.forEach((doc) => {
      const notifRef = db.collection("notifications").doc();
      batch.set(notifRef, {
        userId: doc.id,
        title: "New Civic Report Filed",
        body: `Report #${context.params.reportId} (${reportData.category}): ${reportData.title}`,
        type: "report_created",
        relatedId: context.params.reportId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });
    });

    await batch.commit();
  });
