import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
import 'package:stock_pilot/presentation/cart/widgets/billing_button_widget.dart';
import 'package:stock_pilot/presentation/cart/widgets/cart_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Cart",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (provider.cartItems.isEmpty) {
                          return const EmptypageMessageWidget(
                            heading: "Cart is empty",
                            label: "Add products to your cart",
                          );
                        }
                        return ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: provider.cartItems.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = provider.cartItems[index];
                            return CartListTileWidget(item: item);
                          },
                        );
                      },
                    ),
                  ),
                  if (provider.cartItems.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: BillingButtonWidget(
                        onPressed: () {
                          final invalidItems = provider.cartItems.where((item) {
                            final stock =
                                int.tryParse(item.product.itemCount ?? '0') ??
                                0;
                            return item.quantity <= 0 || item.quantity > stock;
                          }).toList();
                          if (invalidItems.isNotEmpty) {
                            final names = invalidItems
                                .map((e) => e.product.productName)
                                .join(", ");
                            SnackbarUtil.showSnackBar(
                              context,
                              "Invalid quantity: $names",
                              true,
                            );
                            return;
                          }
                          Navigator.pushNamed(context, AppRoutes.billingPage);
                        },
                        text: "Bill",
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
