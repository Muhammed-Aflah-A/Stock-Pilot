import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_activity_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_card_widget.dart';

// Main Dashboard screen
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final sectionSpacing = (size.height * 0.03).clamp(20.0, 40.0);
    final smallSpacing = (size.height * 0.015).clamp(10.0, 20.0);
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // Custom app bar widget used across the app
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Dashboard",
        centeredTitle: false,
        showAvatar: true,
      ),
      // Navigation drawer
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          // Dismiss keyboard when user drags the screen
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard summary cards
                const DashboardCardWidget(),
                SizedBox(height: sectionSpacing),
                // Section title for activity list
                Text(
                  "Recent Activity",
                  style: TextStyles.sectionHeading(
                    context,
                  ).copyWith(color: ColourStyles.colorBlue),
                ),
                SizedBox(height: smallSpacing),
                // Widget that shows recent stock activities
                const DashboardActivityWidget(),
                SizedBox(height: verticalPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
