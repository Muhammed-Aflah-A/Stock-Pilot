import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 11)
enum NotificationType {
  @HiveField(0)
  add,
  @HiveField(1)
  update,
  @HiveField(2)
  delete,
  @HiveField(3)
  sale,
  @HiveField(4)
  lowStock,
  @HiveField(5)
  outOfStock,
}

@HiveType(typeId: 12)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String subtitle;
  @HiveField(3)
  final String dateTime;
  @HiveField(4)
  final NotificationType type;
  @HiveField(5)
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });
}
