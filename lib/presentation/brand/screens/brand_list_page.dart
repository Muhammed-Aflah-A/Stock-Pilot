import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showleading: false,
        title: "Brand",
        centeredTitle: false,
        showAvatar: true,
      ),
      drawer: const AppDrawer(),
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
                  if (context.mounted) {
                    context.read<DashboardProvider>().loadActivities();
                  }
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
            vertical: currentHeight * 0.01,
          ),
          child: Column(
            children: [
              SearchbarWidget(
                controller: controller,
                onChanged: (value) {
                  context.read<BrandProvider>().searchBrands(value);
                  setState(() {});
                },
                onClear: () {
                  controller.clear();
                  context.read<BrandProvider>().clearSearch();
                  setState(() {});
                },
                hintText: "Search brands",
              ),
              SizedBox(height: currentHeight * 0.02),
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
                    if (provider.filteredBrands.isEmpty) {
                      return const Center(
                        child: SingleChildScrollView(
                          child: EmptypageMessageWidget(
                            heading: "No results found",
                            label: "Try a different brand name",
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.filteredBrands.length,
                      itemBuilder: (context, index) {
                        final brandItem = provider.filteredBrands[index];
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
                                  displayName: brandItem.brand!,
                                  onDelete: () async {
                                    await context
                                        .read<BrandProvider>()
                                        .deleteBrand(index);
                                    if (context.mounted) {
                                      context
                                          .read<DashboardProvider>()
                                          .loadActivities();
                                    }
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
