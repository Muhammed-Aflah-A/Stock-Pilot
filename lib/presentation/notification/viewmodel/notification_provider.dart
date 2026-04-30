import 'package:flutter/material.dart';
import 'package:stock_pilot/core/utils/date_util.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/data/models/notification_model.dart';
import 'package:stock_pilot/data/service%20layer/hive_service_layer.dart';

class NotificationProvider with ChangeNotifier {
  final HiveServiceLayer hiveService;

  NotificationProvider({required this.hiveService}) {
    loadNotifications();
  }

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  List<NotificationModel> get readNotifications =>
      _notifications.where((n) => n.isRead).toList();

  Future<void> loadNotifications() async {
    _notifications = await hiveService.getAllNotifications();
    notifyListeners();
  }

  String get unreadCountFormatted {
    final count = unreadNotifications.length;
    if (count == 0) return '';
    return NumberFormatterUtil.format(count);
  }

  Future<void> addNotification({
    required String title,
    required String subtitle,
    required NotificationType type,
  }) async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      dateTime: DateUtil.now(),
      type: type,
    );
    await hiveService.addNotification(notification);
    await loadNotifications();
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    notification.isRead = true;
    await hiveService.updateNotification(notification);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await hiveService.markAllNotificationsAsRead();
    await loadNotifications();
  }

  Future<void> clearAll() async {}
}
