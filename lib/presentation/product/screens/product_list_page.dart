import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/floatingactionbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sortbutton_widget.dart';

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
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.04).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final spacing = (size.height * 0.02).clamp(12.0, 20.0);
    final itemSpacing = (size.height * 0.015).clamp(8.0, 16.0);
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Product",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingactionbuttonWidget(
        onPressed: () {
          context.read<ProductProvider>().resetForm();
          Navigator.pushNamed(context, AppRoutes.productAddingPage1);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchbarWidget(
                          controller: controller,
                          hintText: "Search by name",
                          onChanged: (value) {
                            context.read<ProductProvider>().searchProducts(
                              value,
                            );
                          },
                          onClear: () {
                            controller.clear();
                            context.read<ProductProvider>().clearSearch();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer<ProductProvider>(
                        builder: (context, provider, _) {
                          return FilterbuttonWidget(provider: provider);
                        },
                      ),
                      const SizedBox(width: 10),
                      Consumer<ProductProvider>(
                        builder: (context, provider, _) {
                          return SortbuttonWidget<SortOption>(
                            options: const {
                              SortOption.priceLowToHigh: 'Price : Low to High',
                              SortOption.priceHighToLow: 'Price : High to Low',
                              SortOption.alphabeticalAZ:
                                  'Alphabetical ( A – Z )',
                              SortOption.alphabeticalZA:
                                  'Alphabetical ( Z – A )',
                            },
                            currentValue: provider.currentSort,
                            defaultValue: SortOption.priceLowToHigh,
                            onSelected: (value) => provider.sortProducts(value),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                        if (provider.products.isEmpty) {
                          return const Center(
                            child: EmptypageMessageWidget(
                              heading: "No products yet",
                              label: "Add your first product to get started",
                            ),
                          );
                        }
                        if (provider.filteredProducts.isEmpty) {
                          return const Center(
                            child: EmptypageMessageWidget(
                              icon: Icons.search_off_rounded,
                              heading: "No results found",
                              label: "Try a different product name",
                            ),
                          );
                        }
                        return ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: provider.filteredProducts.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: itemSpacing),
                          itemBuilder: (context, index) {
                            final product = provider.filteredProducts[index];
                            return ProductListTileWidget(
                              product: product,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.productDetailsPage,
                                  arguments: {
                                    'product': product,
                                    'index': index,
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
      ),
    );
  }
}