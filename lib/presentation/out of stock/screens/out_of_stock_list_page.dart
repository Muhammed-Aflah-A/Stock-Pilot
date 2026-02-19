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
        title: "Out of Stock",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
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
                              context.read<ProductProvider>().searchOutOfStock(
                                value,
                              );
                            },
                            onClear: () {
                              controller.clear();
                              context
                                  .read<ProductProvider>()
                                  .clearOutOfStockSearch();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const FilterbuttonWidget(),
                        const SizedBox(width: 10),
                        const SortbuttonWidget(),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Expanded(
                      child: Consumer<ProductProvider>(
                        builder: (context, provider, _) {
                          final displayList = provider.filteredOutOfStock;

                          if (provider.outOfStockProducts.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                heading: "No Out of stock yet",
                                label: "Check here for out of stock product",
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

                          return ListView.separated(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: displayList.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: itemSpacing),
                            itemBuilder: (context, index) {
                              final product = displayList[index];

                              return ProductListTileWidget(
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
      ),
    );
  }
}
