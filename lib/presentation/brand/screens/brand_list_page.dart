import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/delete_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterlist_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/floatingactionbutton_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';

class BrandListPage extends StatefulWidget {
  const BrandListPage({super.key});

  @override
  State<BrandListPage> createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: false,
        title: "Brand",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingactionbuttonWidget(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return EditDetailsWidget(
                maxlength: 30,
                title: "Brand",
                fieldtype: "brand",
                screenWidth: currentWidth,
                isEditing: false,
                onSave: (value) async {
                  final newBrand = BrandModel(brand: value);
                  await context.read<BrandProvider>().addBrand(newBrand);
                },
              );
            },
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: currentWidth * 0.04,
            vertical: currentHeigth * 0.01,
          ),
          child: Column(
            children: [
              SearchbarWidget(
                controller: controller,
                onChanged: (value) {},
                hintText: "Search brands",
              ),
              SizedBox(height: currentHeigth * 0.02),
              Expanded(
                child: Consumer<BrandProvider>(
                  builder: (context, provider, child) {
                    if (provider.brands.isEmpty) {
                      return const Center(
                        child: SingleChildScrollView(
                          child: EmptypageMessageWidget(
                            heading: "No brands yet",
                            label: "Add your first brand to get started",
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.brands.length,
                      itemBuilder: (context, index) {
                        final brandItem = provider.brands[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FilterlistTileWidget(
                            title: brandItem.brand!,
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditDetailsWidget(
                                  maxlength: 30,
                                  title: "Brand",
                                  fieldtype: "brand",
                                  initialValue: brandItem.brand,
                                  screenWidth: currentWidth,
                                  isEditing: true,
                                  onSave: (value) async {
                                    final updatedBrand = BrandModel(
                                      brand: value,
                                    );
                                    await context
                                        .read<BrandProvider>()
                                        .updateBrand(index, updatedBrand);
                                  },
                                ),
                              );
                            },
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (context) => DeleteConfirmationWidget(
                                  title: "Remove Brand",
                                  displayName: brandItem.brand ?? "Unknown",
                                  onDelete: () async {
                                    await context
                                        .read<BrandProvider>()
                                        .deleteBrand(index);
                                  },
                                ),
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
