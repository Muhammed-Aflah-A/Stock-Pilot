import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showleading;
  final String title;
  final bool centeredTitle;
  final bool showAvatar;

  const AppBarWidget({
    super.key,
    required this.showleading,
    required this.title,
    required this.centeredTitle,
    required this.showAvatar,
  });

  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    return size * 1.2;
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.sizeOf(context).width;

    return AppBar(
      backgroundColor: ColourStyles.primaryColor,
      toolbarHeight: _scale(context, 80),
      scrolledUnderElevation: 0,
      leading: showleading
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, size: _scale(context, 20)),
            )
          : null,
      title: Text(title, style: TextStyles.appBarHeading(context)),
      centerTitle: centeredTitle,
      actions: showAvatar
          ? [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: currentWidth * 0.05),
                child: const UserAvatarWidget(),
              ),
            ]
          : null,
    );
  }
}
