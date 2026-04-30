import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

import 'package:stock_pilot/presentation/category/viewmodel/category_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';

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
      drawer: const AppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
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
                        const SizedBox(height: 16),
                        Expanded(
                          child: Consumer<CategoryProvider>(
                            builder: (context, provider, child) {
                              if (provider.categories.isEmpty) {
                                return const Center(
                                  child: EmptypageMessageWidget(
                                    heading: "No categories yet",
                                    label:
                                        "Add your first category to get started",
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
                                padding: const EdgeInsets.only(bottom: 80),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: provider.filteredCategory.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final categoryItem =
                                      provider.filteredCategory[index];
                                  return FilterListTileWidget(
                                    title: categoryItem.category ?? "",
                                    onEdit: () => context
                                        .read<CategoryProvider>()
                                        .onEditCategoryClicked(
                                          context,
                                          categoryItem,
                                          context.read<DashboardProvider>(),
                                        ),
                                    onDelete: () => context
                                        .read<CategoryProvider>()
                                        .onDeleteCategoryClicked(
                                          context,
                                          categoryItem,
                                          context.read<DashboardProvider>(),
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
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButtonWidget(
                  onPressed: () =>
                      context.read<CategoryProvider>().onAddCategoryClicked(
                        context,
                        context.read<DashboardProvider>(),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
