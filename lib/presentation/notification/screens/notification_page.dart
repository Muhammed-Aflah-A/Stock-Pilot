import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/notification_model.dart';
import 'package:stock_pilot/presentation/notification/viewmodel/notification_provider.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColourStyles.primaryColor,
        appBar: AppBarWidget(
          showLeading: true,
          title: "Notifications",
          centeredTitle: false,
          showAvatar: false,
          showNotification: false,
          actions: [
            IconButton(
              onPressed: () => _showMarkAllReadDialog(context),
              icon: const Icon(Icons.done_all_rounded, color: Colors.black),
              tooltip: "Mark all as read",
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: ColourStyles.primaryColor_2,
              unselectedLabelColor: ColourStyles.captionColor,
              indicatorColor: ColourStyles.primaryColor_2,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Unread"),
                Tab(text: "Read"),
              ],
            ),
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, provider, _) {
                  return TabBarView(
                    children: [
                      _buildNotificationList(
                        context,
                        provider.unreadNotifications,
                        provider,
                        "No unread notifications",
                      ),
                      _buildNotificationList(
                        context,
                        provider.readNotifications,
                        provider,
                        "No read notifications",
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationModel> notifications,
    NotificationProvider provider,
    String emptyMessage,
  ) {
    if (notifications.isEmpty) {
      return EmptypageMessageWidget(
        heading: emptyMessage,
        label: "You'll see updates here when products are added, updated or sold",
        icon: Icons.notifications_off_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) =>
          _buildNotificationItem(context, notifications[index], provider),
    );
  }


  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ColourStyles.primaryColor_3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ColourStyles.borderColor),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLeadingIcon(notification.type),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyles.titleText(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    notification.subtitle,
                    style: TextStyles.activityCardText(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.dateTime,
                    style: TextStyles.activityCardLabel(context).copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              IconButton(
                onPressed: () => provider.markAsRead(notification),
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(NotificationType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case NotificationType.add:
        iconData = Icons.add_circle_outline_rounded;
        color = ColourStyles.colorGreen;
        break;
      case NotificationType.update:
        iconData = Icons.edit_note_rounded;
        color = ColourStyles.colorBlue;
        break;
      case NotificationType.delete:
        iconData = Icons.delete_outline_rounded;
        color = ColourStyles.colorRed;
        break;
      case NotificationType.sale:
        iconData = Icons.shopping_cart_outlined;
        color = ColourStyles.colorGreen;
        break;
      case NotificationType.lowStock:
        iconData = Icons.warning_amber_rounded;
        color = ColourStyles.colorYellow;
        break;
      case NotificationType.outOfStock:
        iconData = Icons.error_outline_rounded;
        color = ColourStyles.colorRed;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  void _showMarkAllReadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ActionConfirmationWidget(
        title: "Confirm Action",
        actionText: "Confirm",
        message: "Are you sure you want to mark all notifications as read?",
        actionColor: ColourStyles.colorGreen,
        showSnackbar: false,
        onConfirm: () async {
          await context.read<NotificationProvider>().markAllAsRead();
          return true;
        },
      ),
    );
  }
}
