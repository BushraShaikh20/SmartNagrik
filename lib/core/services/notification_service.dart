import 'package:flutter/foundation.dart';
import '../../models/notification_model.dart';
import '../enums/notification_type.dart';

class NotificationService extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_1',
      userId: 'user_1',
      title: 'Report Resolved',
      message: 'Your report #SN184152 has been resolved by the field officer.',
      type: NotificationType.reportResolved,
      relatedId: 'SN184152',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_2',
      userId: 'user_1',
      title: 'Officer Assigned',
      message: 'Rajesh Patil (Road Maintenance) has been assigned to your report.',
      type: NotificationType.officerAssigned,
      relatedId: 'SN184152',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      userId: 'user_1',
      title: 'Work Progress Updated',
      message: 'Officer updated work progress on report #SN184152: Cleaning in progress.',
      type: NotificationType.progressUpdated,
      relatedId: 'SN184152',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_4',
      userId: 'user_1',
      title: '🚨 Emergency Nearby',
      message: 'Someone nearby needs Medical Assistance (200m away).',
      type: NotificationType.emergencyNearby,
      relatedId: 'EM1001',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_5',
      userId: 'user_1',
      title: 'Citizen Verification Required',
      message: 'Please review and verify the resolution for report #SN184150.',
      type: NotificationType.verificationRequired,
      relatedId: 'SN184150',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void addNotification(NotificationModel notif) {
    _notifications.insert(0, notif);
    notifyListeners();
  }
}
