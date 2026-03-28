import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/filter_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/floating_action_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sort_button_widget.dart';

// Page that displays the list of products
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController controller = TextEditingController();

  /// Dispose the controller when the widget is removed
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // Custom AppBar widget
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Product",
        centeredTitle: false,
        showAvatar: true,
      ),
      // Navigation drawer
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            ConstrainedBox(
              // Prevent page from stretching too wide on large screens
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Top row containing search, filter and sort
                Row(
                  children: [
                    /// Search bar
                    Expanded(
                      child: SearchbarWidget(
                        controller: controller,
                        hintText: "Search by name",
                        onChanged: (value) {
                          provider.searchProducts(value);
                        },
                        onClear: () {
                          controller.clear();
                          provider.clearSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter button
                    FilterButtonWidget(provider: provider),
                    const SizedBox(width: 10),
                    // Sort button
                    SortButtonWidget<SortOption>(
                      options: const {
                        SortOption.priceLowToHigh: 'Price : Low to High',
                        SortOption.priceHighToLow: 'Price : High to Low',
                        SortOption.alphabeticalAZ: 'Alphabetical ( A – Z )',
                        SortOption.alphabeticalZA: 'Alphabetical ( Z – A )',
                      },
                      currentValue: provider.currentSort,
                      defaultValue: SortOption.priceLowToHigh,
                      onSelected: (value) => provider.sortProducts(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Product list section
                Expanded(
                  child: Builder(
                    builder: (context) {
                      // If there are no products in database
                      if (provider.products.isEmpty) {
                        return const EmptypageMessageWidget(
                          heading: "No products yet",
                          label: "Add your first product to get started",
                        );
                      }
                      // If search/filter returns no results
                      if (provider.filteredProducts.isEmpty) {
                        return const EmptypageMessageWidget(
                          icon: Icons.search_off_rounded,
                          heading: "No results found",
                          label: "Try a different product name",
                        );
                      }
                      // Display product list
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 80), // Prevent FAB overlap
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        // Number of products
                        itemCount: provider.filteredProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = provider.filteredProducts[index];
                          final realIndex = provider.products.indexOf(product);
                          return ProductListTileWidget(
                            product: product,
                            // Open product details page
                            onTap: () {
                              provider.setActiveProductIndex(realIndex);
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetailsPage,
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
        // Floating button decoupled from Scaffold to allow Snackbar to flow under it
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButtonWidget(
            onPressed: () {
              // Reset product form before opening add product page
              context.read<ProductProvider>().resetForm();
              // Navigate to product adding page
              Navigator.pushNamed(context, AppRoutes.productAddingPage1);
            },
          ),
        ),
      ],
    ),
  ),
);
  }
}
