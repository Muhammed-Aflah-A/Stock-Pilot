import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/sales_provider.dart';
import 'package:stock_pilot/presentation/cart/widgets/purchase_summary_card_widget.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sale = context.watch<SalesProvider>().latestSale;
    final drawerProvider = context.read<DrawerProvider>();
    if (sale == null) {
      return const Scaffold(body: Center(child: Text("No sale data")));
    }
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // Custom appbar
      appBar: AppBarWidget(
        showLeading: true,
        title: "Confirmation",
        centeredTitle: true,
        showAvatar: false,
        onLeadingTap: () {
          drawerProvider.selectedDrawerItem(1);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Success icon
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: ColourStyles.colorGreen,
                  child: Icon(
                    Icons.check,
                    color: ColourStyles.primaryColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                // product sold text
                Text(
                  "Product Sold Successfully!",
                  style: TextStyles.tagLine(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // widget that shows purchase summary
                PurchaseSummaryCardWidget(
                  name: sale.customerName,
                  phone: sale.customerNumber,
                  date: sale.date,
                  items: sale.items,
                  totalAmount: sale.totalAmount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
