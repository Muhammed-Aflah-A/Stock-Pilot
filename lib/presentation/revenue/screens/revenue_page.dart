import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';

import 'package:provider/provider.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';
import 'package:stock_pilot/presentation/revenue/widgets/most_sold_items_widget.dart';
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
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Revenue",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Consumer<RevenueProvider>(
              builder: (context, provider, child) {
                final isCustom = provider.selectedPeriod == TrendPeriod.custom;
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SalesTrendsWidget(),
                      const SizedBox(height: 20),
                      if (isCustom)
                        RevenueCardWidget(
                          title: "Custom Range Revenue",
                          amount: provider.totalForSelectedPeriod,
                        )
                      else ...[
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
                      ],
                      const SizedBox(height: 20),
                      const MostSoldItemsWidget(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
