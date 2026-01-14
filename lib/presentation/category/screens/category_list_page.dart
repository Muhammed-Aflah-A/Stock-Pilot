import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/floatingactionbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: false,
        title: "Category",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingactionbuttonWidget(onPressed: () {}),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: currentHeigth * 0.01,
            horizontal: currentWidth * 0.03,
          ),
          child: Column(
            children: [
              Expanded(
                child: SearchbarWidget(
                  controller: controller,
                  onChanged: (value) {},
                  hintText: "Search by name",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
