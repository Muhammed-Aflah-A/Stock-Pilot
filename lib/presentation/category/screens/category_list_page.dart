import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/presentation/category/viewmodel/category_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filter_list_tile_widget.dart';
import 'package:stock_pilot/presentation/widgets/floating_action_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  // Controller used for the search field
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
        showLeading: false,
        title: "Category",
        centeredTitle: false,
        showAvatar: true,
      ),
      // Drawer menu
      drawer: const AppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
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
                    // Search bar for categories
                    SearchbarWidget(
                      controller: controller,
                      hintText: "Search categories",
                      // Filter categories when typing
                      onChanged: (value) {
                        context.read<CategoryProvider>().searchCategories(
                          value,
                        );
                      },
                      // Clear search
                      onClear: () {
                        controller.clear();
                        context.read<CategoryProvider>().clearSearch();
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, child) {
                          // If there are no categories
                          if (provider.categories.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                heading: "No categories yet",
                                label: "Add your first category to get started",
                              ),
                            );
                          }
                          // If search returns no results
                          if (provider.filteredCategory.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                icon: Icons.search_off_rounded,
                                heading: "No results found",
                                label: "Try a different category name",
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 80), // Prevent FAB overlap
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: provider.filteredCategory.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final categoryItem =
                                  provider.filteredCategory[index];
                              return FilterListTileWidget(
                                // Category name
                                title: categoryItem.category ?? "",
                                // Edit category
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditDetailsWidget(
                                      maxLength: 30,
                                      title: "Category",
                                      fieldType: "category",
                                      initialValue: categoryItem.category,
                                      isEditing: true,
                                      // Duplicate validation
                                      duplicateValidator: (value) {
                                        if (value.trim().toLowerCase() == categoryItem.category?.toLowerCase()) return null;
                                        final exists = context.read<CategoryProvider>().categories.any(
                                              (c) => c.category?.toLowerCase() == value.trim().toLowerCase(),
                                            );
                                        return exists ? "Category already exists" : null;
                                      },
                                      onSave: (value) async {
                                        final updatedCategory = CategoryModel(
                                          category: value,
                                        );
                                        final realIndex = context.read<CategoryProvider>().categories.indexOf(categoryItem);
                                        if (realIndex != -1) {
                                          await context
                                              .read<CategoryProvider>()
                                              .updateCategory(
                                                realIndex,
                                                updatedCategory,
                                                context.read<DashboardProvider>(),
                                              );
                                        }
                                      },
                                    ),
                                  );
                                },
                                // Delete category
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ActionConfirmationWidget(
                                      title: "Remove Category",
                                      displayName: categoryItem.category ?? "",
                                      actionText: "Remove",
                                      actionColor: ColourStyles.colorRed,
                                      onConfirm: () async {
                                        final canDelete = await context
                                            .read<CategoryProvider>()
                                            .canDeleteCategory(
                                              categoryItem.category ?? "",
                                            );
                                        if (!context.mounted) return false;
                                        if (!canDelete) {
                                          Navigator.pop(context);
                                          SnackbarUtil.showSnackBar(
                                            context,
                                            '"${categoryItem.category}" is used by one or more products and cannot be deleted',
                                            true,
                                          );
                                          return false;
                                        }
                                        final realIndex = context.read<CategoryProvider>().categories.indexOf(categoryItem);
                                        if (realIndex != -1) {
                                          await context
                                              .read<CategoryProvider>()
                                              .deleteCategory(
                                                realIndex,
                                                context.read<DashboardProvider>(),
                                              );
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
                          title: "Category",
                          fieldType: "category",
                          isEditing: false,
                          // Duplicate Validation
                          duplicateValidator: (value) {
                            final exists = context.read<CategoryProvider>().categories.any(
                                  (c) => c.category?.toLowerCase() == value.trim().toLowerCase(),
                                );
                            return exists ? "Category already exists" : null;
                          },
                          // Save new category
                          onSave: (value) async {
                            final newCategory = CategoryModel(category: value);
                            await context.read<CategoryProvider>().addCategory(
                              newCategory,
                              context.read<DashboardProvider>(),
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
