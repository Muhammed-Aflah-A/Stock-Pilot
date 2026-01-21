import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_activity_widget.dart';
import 'package:stock_pilot/presentation/dashboard/widgets/dashboard_card_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Dashboard",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                  vertical: constraints.maxHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardCardWidget(),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Text(
                      "Recent Activity",
                      style: TextStyles.recentActivity(context),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.015),
                    const DashboardActivityWidget(),
                    SizedBox(height: constraints.maxHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
