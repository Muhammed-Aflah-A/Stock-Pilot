import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/brand_model.dart';
import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filter_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/floating_action_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';

class BrandListPage extends StatefulWidget {
  const BrandListPage({super.key});

  @override
  State<BrandListPage> createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  // Controller used for search field
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.read<DashboardProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Brand",
        centeredTitle: false,
        showAvatar: true,
      ),
      // Drawer menu
      drawer: const AppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Close keyboard when tapping outside
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Search bar for brands
                    SearchbarWidget(
                      controller: controller,
                      hintText: "Search brands",
                      // Filter brand when typing
                      onChanged: (value) {
                        context.read<BrandProvider>().searchBrands(value);
                      },
                      // Clear search
                      onClear: () {
                        controller.clear();
                        context.read<BrandProvider>().clearSearch();
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<BrandProvider>(
                        builder: (context, provider, child) {
                          // If there are no categories
                          if (provider.brands.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                heading: "No brands yet",
                                label: "Add your first brand to get started",
                              ),
                            );
                          }
                          // If search returns no results
                          if (provider.filteredBrands.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                icon: Icons.search_off_rounded,
                                heading: "No results found",
                                label: "Try a different brand name",
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 80), // Prevent FAB overlap
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: provider.filteredBrands.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final brandItem = provider.filteredBrands[index];
                              return FilterListTileWidget(
                                // Brand name
                                title: brandItem.brand ?? "",
                                // Edit brand
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditDetailsWidget(
                                      maxLength: 30,
                                      title: "Brand",
                                      fieldType: "brand",
                                      initialValue: brandItem.brand,
                                      isEditing: true,
                                      // Duplicate Validation
                                      duplicateValidator: (value) {
                                        // Ignore self
                                        if (value.trim().toLowerCase() == brandItem.brand?.toLowerCase()) return null;
                                        final exists = context.read<BrandProvider>().brands.any(
                                              (b) => b.brand?.toLowerCase() == value.trim().toLowerCase(),
                                            );
                                        return exists ? "Brand already exists" : null;
                                      },
                                      onSave: (value) async {
                                        final updatedBrand = BrandModel(
                                          brand: value,
                                        );
                                        final realIndex = context.read<BrandProvider>().brands.indexOf(brandItem);
                                        if (realIndex != -1) {
                                          await context
                                              .read<BrandProvider>()
                                              .updateBrand(
                                                realIndex,
                                                updatedBrand,
                                                dashboard,
                                              );
                                        }
                                      },
                                    ),
                                  );
                                },
                                // Delete brand
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ActionConfirmationWidget(
                                      title: "Remove Brand",
                                      displayName: brandItem.brand ?? "",
                                      actionText: "Remove",
                                      actionColor: ColourStyles.colorRed,
                                      onConfirm: () async {
                                        final canDelete = await context
                                            .read<BrandProvider>()
                                            .canDeleteBrand(
                                              brandItem.brand ?? "",
                                            );
                                        if (!context.mounted) return false;
                                        if (!canDelete) {
                                          Navigator.pop(context);
                                          SnackbarUtil.showSnackBar(
                                            context,
                                            '"${brandItem.brand}" is used by one or more products and cannot be deleted',
                                            true,
                                          );
                                          return false;
                                        }
                                        final realIndex = context.read<BrandProvider>().brands.indexOf(brandItem);
                                        if (realIndex != -1) {
                                          await context
                                              .read<BrandProvider>()
                                              .deleteBrand(realIndex, dashboard);
                                        }
                                        return true;
                                      },
                                    ),
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
              // Floating action button manually positioned over list
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButtonWidget(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditDetailsWidget(
                          maxLength: 30,
                          title: "Brand",
                          fieldType: "brand",
                          isEditing: false,
                          // Duplicate Validation
                          duplicateValidator: (value) {
                            final exists = context.read<BrandProvider>().brands.any(
                                  (b) => b.brand?.toLowerCase() == value.trim().toLowerCase(),
                                );
                            return exists ? "Brand already exists" : null;
                          },
                          // Save new brand
                          onSave: (value) async {
                            final newBrand = BrandModel(brand: value);
                            await context.read<BrandProvider>().addBrand(
                              newBrand,
                              dashboard,
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
    );
  }
}
