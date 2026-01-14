import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/floatingactionbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/noproduct_Message_widget.dart';
import 'package:stock_pilot/presentation/widgets/product_list_tile_widget.dart';
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
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: false,
        title: "Product",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingactionbuttonWidget(
        onPressed: () {
          context.read<ProductProvider>().resetForm();
          Navigator.pushNamed(context, AppRoutes.productAddingPage1);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: currentHeigth * 0.01,
            horizontal: currentWidth * 0.03,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(
                      controller: controller,
                      onChanged: (value) {},
                      hintText: "Search by name",
                    ),
                  ),
                  SizedBox(width: currentWidth * 0.01),
                  FilterbuttonWidget(),
                  SizedBox(width: currentWidth * 0.01),
                  SortbuttonWidget(),
                ],
              ),
              SizedBox(height: currentHeigth * 0.03),
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    if (provider.products.isEmpty) {
                      return NoproductMessageWidget();
                    }
                    return ListView.builder(
                      itemCount: provider.products.length,
                      itemBuilder: (context, index) {
                        final product = provider.products[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: currentHeigth * 0.01,
                          ),
                          child: ProductListTileWidget(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetailsPage,
                                arguments: {'product': product, 'index': index},
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
        ),
      ),
    );
  }
}
