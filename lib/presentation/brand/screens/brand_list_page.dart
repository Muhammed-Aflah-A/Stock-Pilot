import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

import 'package:stock_pilot/presentation/brand/viewmodel/brand_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';

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
                          hintText: "Search brands",
                          onChanged: (value) {
                            context.read<BrandProvider>().searchBrands(value);
                          },
                          onClear: () {
                            controller.clear();
                            context.read<BrandProvider>().clearSearch();
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Consumer<BrandProvider>(
                            builder: (context, provider, child) {
                              if (provider.brands.isEmpty) {
                                return const Center(
                                  child: EmptypageMessageWidget(
                                    heading: "No brands yet",
                                    label:
                                        "Add your first brand to get started",
                                  ),
                                );
                              }
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
                                padding: const EdgeInsets.only(bottom: 80),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: provider.filteredBrands.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final brandItem =
                                      provider.filteredBrands[index];
                                  return FilterListTileWidget(
                                    title: brandItem.brand ?? "",
                                    onEdit: () => context
                                        .read<BrandProvider>()
                                        .onEditBrandClicked(
                                          context,
                                          brandItem,
                                          dashboard,
                                        ),
                                    onDelete: () => context
                                        .read<BrandProvider>()
                                        .onDeleteBrandClicked(
                                          context,
                                          brandItem,
                                          dashboard,
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
                  onPressed: () => context
                      .read<BrandProvider>()
                      .onAddBrandClicked(context, dashboard),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
