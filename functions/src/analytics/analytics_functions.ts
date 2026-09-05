import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const aggregateDailyAnalytics = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async () => {
    const db = admin.firestore();
    const reportsSnap = await db.collection("reports").get();

    let total = 0;
    let pending = 0;
    let inProgress = 0;
    let resolved = 0;
    const categoryCount: Record<string, number> = {};

    reportsSnap.forEach((doc) => {
      const data = doc.data();
      total++;
      if (data.status === "submitted" || data.status === "pending") pending++;
      else if (data.status === "inProgress") inProgress++;
      else if (data.status === "resolved" || data.status === "closed") resolved++;

      const cat = data.category || "other";
      categoryCount[cat] = (categoryCount[cat] || 0) + 1;
    });

    await db.collection("analytics").doc("overview").set({
      totalReports: total,
      pendingReports: pending,
      inProgressReports: inProgress,
      resolvedReports: resolved,
      reportsByCategory: categoryCount,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });
