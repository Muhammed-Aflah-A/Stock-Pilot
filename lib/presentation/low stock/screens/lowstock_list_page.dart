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

class LowstockListPage extends StatefulWidget {
  const LowstockListPage({super.key});

  @override
  State<LowstockListPage> createState() => _LowstockListPageState();
}

class _LowstockListPageState extends State<LowstockListPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Low Stock",
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
                            onChanged: (value) {},
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
                        final lowStockList = provider.lowStockProducts;
                        if (lowStockList.isEmpty) {
                          return const Center(
                            child: SingleChildScrollView(
                              child: EmptypageMessageWidget(
                                heading: "No Low stock yet",
                                label: "check here for low stock product",
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: lowStockList.length,
                          itemBuilder: (context, index) {
                            final product = lowStockList[index];
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
