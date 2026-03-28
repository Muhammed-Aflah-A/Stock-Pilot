import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/user_avatar_widget.dart';

// AppBar widget for all screen
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final String title;
  final bool centeredTitle;
  final bool showAvatar;
  final VoidCallback? onLeadingTap;

  const AppBarWidget({
    super.key,
    required this.showLeading,
    required this.title,
    required this.centeredTitle,
    required this.showAvatar,
    this.onLeadingTap,
  });
  // fixed height for AppBar
  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColourStyles.primaryColor,
      scrolledUnderElevation: 0,
      // show back button only if needed
      leading: showLeading
          ? IconButton(
              onPressed: onLeadingTap ?? () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            )
          : null,
      // title text
      title: Text(title, style: TextStyles.appBarHeading(context)),
      centerTitle: centeredTitle,
      // avatar on right side
      actions: showAvatar
          ? const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: UserAvatarWidget(),
              ),
            ]
          : null,
    );
  }
}
