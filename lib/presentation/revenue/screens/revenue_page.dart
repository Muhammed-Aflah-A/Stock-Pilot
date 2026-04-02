import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';

import 'package:provider/provider.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';
import 'package:stock_pilot/presentation/revenue/widgets/revenue_card_widget.dart';
import 'package:stock_pilot/presentation/revenue/widgets/sales_trends_widget.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor_3,
      // APP BAR
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Revenue",
        centeredTitle: false,
        showAvatar: true,
      ),
      // DRAWER
      drawer: const AppDrawer(),
      body: Consumer<RevenueProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                RevenueCardWidget(
                  title: "Daily Revenue",
                  amount: provider.dailyRevenue,
                ),
                RevenueCardWidget(
                  title: "Monthly Revenue",
                  amount: provider.monthlyRevenue,
                ),
                RevenueCardWidget(
                  title: "Yearly Revenue",
                  amount: provider.yearlyRevenue,
                ),
                const SizedBox(height: 8),
                const SalesTrendsWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
