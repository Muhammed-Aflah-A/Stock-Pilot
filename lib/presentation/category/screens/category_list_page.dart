import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/category_model.dart';
import 'package:stock_pilot/presentation/category/viewmodel/category_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/delete_confirmation_widget.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filterlist_tile_widget.dart';
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
        title: "Category",
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
                title: "Category",
                fieldtype: "category",
                screenWidth: size.width,
                isEditing: false,
                onSave: (value) async {
                  final newCategory = CategoryModel(category: value);
                  await context.read<CategoryProvider>().addCategory(
                    newCategory,
                  );
                },
              );
            },
          );
        },
      ),
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
                    SearchbarWidget(
                      controller: controller,
                      hintText: "Search categories",
                      onChanged: (value) {
                        context.read<CategoryProvider>().searchCategories(
                          value,
                        );
                      },
                      onClear: () {
                        controller.clear();
                        context.read<CategoryProvider>().clearSearch();
                      },
                    ),
                    SizedBox(height: spacing),
                    Expanded(
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, child) {
                          if (provider.categories.isEmpty) {
                            return const Center(
                              child: EmptypageMessageWidget(
                                heading: "No categories yet",
                                label: "Add your first category to get started",
                              ),
                            );
                          }

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
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: provider.filteredCategory.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: itemSpacing),
                            itemBuilder: (context, index) {
                              final categoryItem =
                                  provider.filteredCategory[index];

                              return FilterlistTileWidget(
                                title: categoryItem.category!,
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditDetailsWidget(
                                      maxlength: 30,
                                      title: "Category",
                                      fieldtype: "category",
                                      initialValue: categoryItem.category,
                                      screenWidth: size.width,
                                      isEditing: true,
                                      onSave: (value) async {
                                        final updatedCategory = CategoryModel(
                                          category: value,
                                        );
                                        await context
                                            .read<CategoryProvider>()
                                            .updateCategory(
                                              index,
                                              updatedCategory,
                                            );
                                      },
                                    ),
                                  );
                                },
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => DeleteConfirmationWidget(
                                      title: "Remove Category",
                                      displayName: categoryItem.category!,
                                      onDelete: () async {
                                        final canDelete = await context
                                            .read<CategoryProvider>()
                                            .canDeleteCategory(
                                              categoryItem.category!,
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
                                        await context
                                            .read<CategoryProvider>()
                                            .deleteCategory(index);
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
        ),
      ),
    );
  }
}
