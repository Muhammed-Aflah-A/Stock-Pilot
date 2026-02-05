import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/product_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sortbutton_widget.dart';

class OutOfStockListPage extends StatefulWidget {
  const OutOfStockListPage({super.key});

  @override
  State<OutOfStockListPage> createState() => _OutOfStockListPageState();
}

class _OutOfStockListPageState extends State<OutOfStockListPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Out of Stock",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
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
                              context.read<ProductProvider>().searchOutOfStock(
                                value,
                              );
                              setState(() {});
                            },
                            onClear: () {
                              controller.clear();
                              context
                                  .read<ProductProvider>()
                                  .clearOutOfStockSearch();
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
                        final displayList = provider.filteredOutOfStock;
                        if (provider.outOfStockProducts.isEmpty) {
                          return const Center(
                            child: SingleChildScrollView(
                              child: EmptypageMessageWidget(
                                heading: "No Out of stock yet",
                                label: "check here for out of stock product",
                              ),
                            ),
                          );
                        }
                        if (displayList.isEmpty) {
                          return const Center(
                            child: EmptypageMessageWidget(
                              heading: "No matches",
                              label:
                                  "No out of stock products match your search",
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            final product = displayList[index];
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
                                      'index': provider.products.indexOf(
                                        product,
                                      ),
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
