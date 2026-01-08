import 'package:flutter/material.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/floatingactionbutton_widget.dart';
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
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
          Navigator.pushNamed(context, AppRoutes.productAddingPage1);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: h * 0.01,
            horizontal: h * 0.01,
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
                  SizedBox(width: w * 0.01),
                  FilterbuttonWidget(),
                  SizedBox(width: w * 0.01),
                  SortbuttonWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
