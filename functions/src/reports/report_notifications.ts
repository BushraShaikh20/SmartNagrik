import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const onReportStatusChanged = functions.firestore
  .document("reports/{reportId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.status !== after.status) {
      const db = admin.firestore();
      
      // Notify citizen of progress
      await db.collection("notifications").add({
        userId: after.citizenId,
        title: `Report Status Updated: ${after.status.toUpperCase()}`,
        body: `Your report #${context.params.reportId} status has changed to ${after.status}.`,
        type: "progressUpdated",
        relatedId: context.params.reportId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });
    }
  });
