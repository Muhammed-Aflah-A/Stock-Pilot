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

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController controller = TextEditingController();

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
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Product",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
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
                          FilterButtonWidget(provider: provider),
                          const SizedBox(width: 10),
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
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (provider.products.isEmpty) {
                              return const EmptypageMessageWidget(
                                heading: "No products yet",
                                label: "Add your first product to get started",
                              );
                            }
                            if (provider.filteredProducts.isEmpty) {
                              return const EmptypageMessageWidget(
                                icon: Icons.search_off_rounded,
                                heading: "No results found",
                                label: "Try a different product name",
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.only(bottom: 80),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: provider.filteredProducts.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final product = provider.filteredProducts[index];
                                final realIndex = provider.products.indexOf(product);
                                return ProductListTileWidget(
                                  product: product,
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
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButtonWidget(
                onPressed: () {
                  context.read<ProductProvider>().resetForm();
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
