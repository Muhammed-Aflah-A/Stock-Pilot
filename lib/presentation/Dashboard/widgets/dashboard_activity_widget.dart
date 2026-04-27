import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/activity_card_widget.dart';

class DashboardActivityWidget extends StatelessWidget {
  const DashboardActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final activities = provider.recentActivities;
        if (activities.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Center(
              child: Text(
                "No recent activities found",
                style: TextStyles.primaryText(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ActivityCardWidget(activity: activity);
          },
        );
      },
    );
  }
}
