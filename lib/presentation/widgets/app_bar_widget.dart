import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Size get preferredSize => const Size.fromHeight(90);
  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColourStyles.primaryColor,
      ),
      backgroundColor: ColourStyles.primaryColor,
      toolbarHeight: currentHeigth * 0.1,
      scrolledUnderElevation: 0,
      leading: showleading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            )
          : null,
      title: Text(title, style: TextStyles.dialogueHeading(context)),
      centerTitle: centeredTitle,
      actions: showAvatar
          ? [
              Padding(
                padding: EdgeInsets.all(currentHeigth * 0.02),
                child: UserAvatarWidget(),
              ),
            ]
          : null,
    );
  }
}
