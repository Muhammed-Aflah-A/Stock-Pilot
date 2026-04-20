import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/contact_dialog_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Settings",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Privacy and Policy Tile
          Card(
            elevation: 0,
            color: ColourStyles.primaryColor_3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: ColourStyles.borderColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: ColourStyles.primaryColor_2),
              title: Text(
                "Privacy and Policy",
                style: TextStyles.titleText(context),
              ),
              trailing: const Icon(Icons.chevron_right, color: ColourStyles.iconColor),
              onTap: () => Navigator.pushNamed(context, AppRoutes.privacyPolicy),
            ),
          ),
          const SizedBox(height: 12),
          
          // About Us Tile
          Card(
            elevation: 0,
            color: ColourStyles.primaryColor_3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: ColourStyles.borderColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: ColourStyles.primaryColor_2),
              title: Text(
                "About Us",
                style: TextStyles.titleText(context),
              ),
              trailing: const Icon(Icons.chevron_right, color: ColourStyles.iconColor),
              onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
            ),
          ),
          const SizedBox(height: 12),
          
          // Contact and Support Tile
          Card(
            elevation: 0,
            color: ColourStyles.primaryColor_3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: ColourStyles.borderColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.contact_support_outlined, color: ColourStyles.primaryColor_2),
              title: Text(
                "Contact and Support",
                style: TextStyles.titleText(context),
              ),
              trailing: const Icon(Icons.chevron_right, color: ColourStyles.iconColor),
              onTap: () => ContactDialogWidget.show(context),
            ),
          ),
        ],
      ),
    );
  }
}
