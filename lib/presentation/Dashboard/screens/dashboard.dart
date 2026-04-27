import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_activity_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_card_widget.dart';

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
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Dashboard",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardCardWidget(),
                    SizedBox(height: sectionSpacing),
                    Text(
                      "Recent Activity",
                      style: TextStyles.sectionHeading(
                        context,
                      ).copyWith(color: ColourStyles.colorBlue),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: smallSpacing),
                    const DashboardActivityWidget(),
                    SizedBox(height: verticalPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
