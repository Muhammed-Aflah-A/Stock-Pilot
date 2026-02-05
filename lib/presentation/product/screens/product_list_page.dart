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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.04,
                vertical: constraints.maxHeight * 0.01,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.07,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SearchbarWidget(
                            controller: controller,
                            onChanged: (value) {
                              context.read<ProductProvider>().searchProducts(
                                value,
                              );
                              setState(() {});
                            },
                            onClear: () {
                              controller.clear();
                              context.read<ProductProvider>().clearSearch();
                              setState(() {});
                            },
                            hintText: "Search by name",
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.02),
                        const FilterbuttonWidget(),
                        SizedBox(width: constraints.maxWidth * 0.02),
                        const SortbuttonWidget(),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, provider, child) {
                        if (provider.products.isEmpty) {
                          return const Center(
                            child: SingleChildScrollView(
                              child: EmptypageMessageWidget(
                                heading: "No products yet",
                                label: "Add your first product to get started",
                              ),
                            ),
                          );
                        }
                        if (provider.filteredProducts.isEmpty) {
                          return const Center(
                            child: SingleChildScrollView(
                              child: EmptypageMessageWidget(
                                heading: "No results found",
                                label: "Try a different product name",
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: provider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = provider.filteredProducts[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: constraints.maxHeight * 0.015,
                              ),
                              child: ProductListTileWidget(
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
