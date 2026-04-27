import 'package:flutter/material.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "About Us",
        centeredTitle: false,
        showAvatar: false,
        showNotification: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppImages.appLogo2,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.business_center_rounded,
                        size: 60,
                        color: ColourStyles.iconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Stock-Pilot",
                  style: TextStyles.titleText(context).copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Your Personal Inventory Assistant",
                  style: TextStyles.activityCardLabel(
                    context,
                  ).copyWith(color: ColourStyles.pilotTextColor),
                ),
                const SizedBox(height: 20),
                Text(
                  "At Stock-Pilot, we believe inventory management should be simple, intuitive, and powerful. Our mission is to empower small business owners and creators to take full control of their stock, sales, and revenue with ease.",
                  textAlign: TextAlign.center,
                  style: TextStyles.activityCardText(
                    context,
                  ).copyWith(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  "Version 1.0.0",
                  style: TextStyles.activityCardLabel(context),
                ),
                const SizedBox(height: 8),
                Text(
                  "© 2026 Stock-Pilot Team",
                  style: TextStyles.activityCardLabel(
                    context,
                  ).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
