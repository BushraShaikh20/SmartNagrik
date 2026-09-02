import * as admin from "firebase-admin";

admin.initializeApp();

export * from "./auth/auth_functions";
export * from "./reports/report_functions";
export * from "./reports/report_notifications";
export * from "./tasks/task_functions";
export * from "./emergency/emergency_functions";
export * from "./notifications/notification_functions";
export * from "./analytics/analytics_functions";
