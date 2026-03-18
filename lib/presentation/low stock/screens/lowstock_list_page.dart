import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/low stock/viewmodel/lowStock_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/product_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filter_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sort_button_widget.dart';

class LowstockListPage extends StatefulWidget {
  const LowstockListPage({super.key});

  @override
  State<LowstockListPage> createState() => _LowstockListPageState();
}

class _LowstockListPageState extends State<LowstockListPage> {
  // Controller for search input
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.04).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final spacing = (size.height * 0.02).clamp(12.0, 20.0);
    final itemSpacing = (size.height * 0.015).clamp(8.0, 16.0);

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // Custom app bar
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Low Stock",
        centeredTitle: false,
        showAvatar: true,
      ),
      // Side drawer
      drawer: const AppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Close keyboard when tapping outside
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: SearchbarWidget(
                        controller: controller,
                        hintText: "Search by name",
                        onChanged: (value) {
                          context.read<LowstockProvider>().searchLowStock(
                            value,
                          );
                        },
                        // Clear search
                        onClear: () {
                          controller.clear();
                          context.read<LowstockProvider>().clearSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter button
                    Consumer<LowstockProvider>(
                      builder: (_, provider, _) =>
                          FilterButtonWidget(provider: provider),
                    ),
                    const SizedBox(width: 10),
                    // Sort button
                    Consumer<LowstockProvider>(
                      builder: (_, provider, _) =>
                          SortButtonWidget<LowStockSortOption>(
                            options: const {
                              LowStockSortOption.priceLowToHigh:
                                  'Price : Low to High',
                              LowStockSortOption.priceHighToLow:
                                  'Price : High to Low',
                              LowStockSortOption.alphabeticalAZ:
                                  'Alphabetical ( A – Z )',
                              LowStockSortOption.alphabeticalZA:
                                  'Alphabetical ( Z – A )',
                            },
                            // Current selected sort
                            currentValue: provider.currentSort,
                            // Default sort
                            defaultValue: LowStockSortOption.priceLowToHigh,
                            // Apply sorting
                            onSelected: provider.sortProducts,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                // Product list
                Expanded(
                  child: Consumer<LowstockProvider>(
                    builder: (context, provider, _) {
                      final displayList = provider.filteredLowStock;
                      // Empty state
                      if (displayList.isEmpty) {
                        return const Center(
                          child: EmptypageMessageWidget(
                            heading: "No Low stock yet",
                            label: "Check here for low stock product",
                          ),
                        );
                      }
                      // Product list
                      return ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: displayList.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: itemSpacing),
                        itemBuilder: (context, index) {
                          final product = displayList[index];
                          return ProductListTileWidget(
                            product: product,
                            // Navigate to details page
                            onTap: () {
                              final mainProvider = context
                                  .read<ProductProvider>();
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetailsPage,
                                arguments: {
                                  'product': product,
                                  'index': mainProvider.products.indexOf(
                                    product,
                                  ),
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
