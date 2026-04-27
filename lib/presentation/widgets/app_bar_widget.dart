import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/notification/viewmodel/notification_provider.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final String title;
  final bool centeredTitle;
  final bool showAvatar;
  final bool showNotification;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;

  const AppBarWidget({
    super.key,
    required this.showLeading,
    required this.title,
    required this.centeredTitle,
    required this.showAvatar,
    this.showNotification = true,
    this.actions,
    this.onLeadingTap,
  });
  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColourStyles.primaryColor,
      scrolledUnderElevation: 0,
      leading: showLeading
          ? IconButton(
              onPressed: onLeadingTap ?? () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            )
          : null,
      title: Text(title, style: TextStyles.appBarHeading(context)),
      centerTitle: centeredTitle,
      actions: [
        if (showNotification)
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              final unreadCount = notificationProvider.unreadCountFormatted;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notificationPage);
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 30,
                    ),
                  ),
                  if (unreadCount.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: ColourStyles.colorRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        if (showAvatar)
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 8),
            child: UserAvatarWidget(),
          ),
        ...?actions,
      ],
    );
  }
}
