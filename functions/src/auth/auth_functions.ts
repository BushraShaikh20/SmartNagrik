import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const db = admin.firestore();
  const userDoc = db.collection("users").doc(user.uid);
  
  await userDoc.set({
    id: user.uid,
    email: user.email || "",
    phoneNumber: user.phoneNumber || "",
    displayName: user.displayName || "Citizen",
    role: "citizen",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    isActive: true,
  }, { merge: true });
});
