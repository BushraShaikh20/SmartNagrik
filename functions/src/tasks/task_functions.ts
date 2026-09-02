import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const onTaskAssigned = functions.firestore
  .document("tasks/{taskId}")
  .onCreate(async (snap, context) => {
    const taskData = snap.data();
    const db = admin.firestore();

    if (taskData.officerId) {
      await db.collection("notifications").add({
        userId: taskData.officerId,
        title: "New Task Assigned",
        body: `You have been assigned to task #${context.params.taskId} for report #${taskData.reportId}.`,
        type: "officerAssigned",
        relatedId: taskData.reportId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });
    }
  });
