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
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColourStyles.primaryColor,
      toolbarHeight: 100,
      leading: showleading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            )
          : null,
      title: Text(title, style: TextStyles.heading_2),
      centerTitle: centeredTitle,
      actions: showAvatar
          ? [Padding(padding: EdgeInsets.all(20), child: UserAvatarWidget())]
          : null,
    );
  }
}
