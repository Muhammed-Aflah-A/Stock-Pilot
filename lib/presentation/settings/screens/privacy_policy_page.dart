import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Privacy Policy",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyles.titleText(
                context,
              ).copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Last updated: April 20, 2026",
              style: TextStyles.activityCardLabel(context),
            ),
            const SizedBox(height: 24),
            Text(
              "1. Information Collection",
              style: TextStyles.primaryText(
                context,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "We collect the information you enter in the app, such as your name, email, phone number, shop details, and product information. This helps the app work properly and manage your data.",
              style: TextStyles.activityCardText(
                context,
              ).copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              "2. Use of Information",
              style: TextStyles.primaryText(
                context,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "We use your information to run the app, manage your account, track inventory, create reports, and provide support. This helps improve your overall experience.",
              style: TextStyles.activityCardText(
                context,
              ).copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              "3. Data Security",
              style: TextStyles.primaryText(
                context,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Your data is stored on your device. We take steps to keep it safe, but your device security (like screen lock) also plays an important role.",
              style: TextStyles.activityCardText(
                context,
              ).copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              "4. Data Persistence",
              style: TextStyles.primaryText(
                context,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Stock Pilot stores all your data locally on your device using Hive. Since the app works offline, your data is not sent anywhere unless you choose to export or share it.",
              style: TextStyles.activityCardText(
                context,
              ).copyWith(height: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
