import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
import 'package:stock_pilot/presentation/history/viewmodel/history_provider.dart';
import 'package:stock_pilot/presentation/cart/widgets/billing_button_widget.dart';
import 'package:stock_pilot/presentation/cart/widgets/billing_form_widget.dart';
import 'package:stock_pilot/presentation/cart/widgets/order_details_widget.dart';
import 'package:stock_pilot/presentation/cart/widgets/order_total_widget.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Billing Details",
        centeredTitle: true,
        showAvatar: false,
        showNotification: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const OrderDetailsWidget(),
                      const SizedBox(height: 10),
                      Card(
                        color: ColourStyles.primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer Details",
                                style: TextStyles.cardHeading(context),
                              ),
                              const SizedBox(height: 10),
                              const BillingFormWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: ColourStyles.primaryColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const OrderTotalWidget(),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: BillingButtonWidget(
                          onPressed: () async {
                            final cart = context.read<CartProvider>();
                            final product = context.read<ProductProvider>();
                            final dashboard = context.read<DashboardProvider>();
                            final sales = context.read<HistoryProvider>();

                            if (!cart.isFormValid) {
                              SnackbarUtil.showSnackBar(
                                context,
                                "Please fill all required customer details",
                                true,
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (dialogCtx) => ActionConfirmationWidget(
                                title: "Confirm Sale",
                                displayName:
                                    "Complete transaction and bill customer?",
                                actionText: "Sell",
                                actionColor: ColourStyles.colorGreen,
                                showSnackbar: false,
                                onConfirm: () async {
                                  final sale = await cart.completeSale(
                                    productProvider: product,
                                    dashboardProvider: dashboard,
                                    historyProvider: sales,
                                  );
                                  if (!dialogCtx.mounted) return false;

                                  if (sale != null) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      dialogCtx,
                                      AppRoutes.confirmationPage,
                                      (route) => false,
                                    );
                                    return false;
                                  } else {
                                    Navigator.pop(dialogCtx);
                                    SnackbarUtil.showSnackBar(
                                      dialogCtx,
                                      "Failed to complete sale. Check stock limits.",
                                      true,
                                    );
                                    return false;
                                  }
                                },
                              ),
                            );
                          },
                          text: "Sell",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
