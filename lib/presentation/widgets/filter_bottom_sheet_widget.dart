import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/brand_choice_widget.dart';
import 'package:stock_pilot/presentation/widgets/category_choice_widget.dart';
import 'package:stock_pilot/presentation/widgets/multi_select_filter_dialog.dart';
import 'package:stock_pilot/presentation/widgets/section_title_widget.dart';
import 'package:stock_pilot/presentation/widgets/stock_status_choice_widget.dart';

class FilterBottomSheet extends StatelessWidget {
  final FilterProviderInterface provider;
  const FilterBottomSheet({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 28.0);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ColourStyles.primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColourStyles.primaryColor_2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter', style: TextStyles.sectionTitle(context)),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: ListenableBuilder(
                  listenable: provider,
                  builder: (context, _) {
                    final effectiveMax = provider.maxPrice > 0
                        ? provider.maxPrice
                        : 5000.0;
                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      children: [
                        if (provider.showCategoryFilter && provider.categoryList.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          SectionTitleWidget(
                            title: provider.tempCategories.isNotEmpty
                                ? "Category (${provider.tempCategories.length})"
                                : "Category",
                          ),
                          const SizedBox(height: 10),
                          if (provider.categoryList.length <= 4)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: provider.categoryList.map((category) {
                                final selected = provider.tempCategories.contains(category);
                                return CategoryChoiceWidget(
                                  label: category,
                                  selected: selected,
                                  onTap: () => provider.toggleTempCategory(category),
                                );
                              }).toList(),
                            )
                          else ...[
                            if (provider.tempCategories.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: provider.tempCategories.map((category) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: CategoryChoiceWidget(
                                          label: category,
                                          selected: true,
                                          onTap: () => provider.toggleTempCategory(category),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => MultiSelectFilterDialog(
                                    provider: provider,
                                    title: 'Category',
                                    isCategory: true,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: ColourStyles.choiceColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColourStyles.borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "View All categories (${provider.categoryList.length})",
                                      style: TextStyles.primaryText(context).copyWith(
                                        fontSize: 14,
                                        color: ColourStyles.primaryColor_2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: ColourStyles.primaryColor_2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                        if (provider.showPriceFilter) ...[
                          const SectionTitleWidget(title: "Price Range"),
                          RangeSlider(
                            min: provider.minPrice,
                            max: effectiveMax,
                            values: RangeValues(
                              provider.tempMinPrice.clamp(provider.minPrice, effectiveMax),
                              provider.tempMaxPrice.clamp(provider.minPrice, effectiveMax),
                            ),
                            activeColor: ColourStyles.primaryColor_2,
                            inactiveColor: ColourStyles.borderColor,
                            onChanged: (RangeValues values) {
                              provider.setTempPriceRange(values.start, values.end);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${provider.tempMinPrice.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: ColourStyles.primaryColor_2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$${provider.tempMaxPrice.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: ColourStyles.primaryColor_2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (provider.showBrandFilter && provider.brandsList.isNotEmpty) ...[
                          SectionTitleWidget(
                            title: provider.tempBrands.isNotEmpty
                                ? "Brand (${provider.tempBrands.length})"
                                : "Brand",
                          ),
                          const SizedBox(height: 10),
                          if (provider.brandsList.length <= 4)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: provider.brandsList.map((brand) {
                                final selected = provider.tempBrands.contains(brand);
                                return BrandChoiceWidget(
                                  label: brand,
                                  selected: selected,
                                  onTap: () => provider.toggleTempBrand(brand),
                                );
                              }).toList(),
                            )
                          else ...[
                            if (provider.tempBrands.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: provider.tempBrands.map((brand) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: BrandChoiceWidget(
                                          label: brand,
                                          selected: true,
                                          onTap: () => provider.toggleTempBrand(brand),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => MultiSelectFilterDialog(
                                    provider: provider,
                                    title: 'Brand',
                                    isCategory: false,
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: ColourStyles.choiceColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColourStyles.borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "View All brands (${provider.brandsList.length})",
                                      style: TextStyles.primaryText(context).copyWith(
                                        fontSize: 14,
                                        color: ColourStyles.primaryColor_2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: ColourStyles.primaryColor_2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                        if (provider.showStockFilter && provider.availableStockStatuses.length > 1) ...[
                          const SectionTitleWidget(title: "Stock Status"),
                          const SizedBox(height: 10),
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.availableStockStatuses.length,
                            itemBuilder: (context, index) {
                              final stockStatus = provider.availableStockStatuses[index];
                              final selected =
                                  provider.tempStockStatus == stockStatus;
                              return StockStatusChoiceWidget(
                                label: stockStatus,
                                selected: selected,
                                onTap: () =>
                                    provider.setTempStockStatus(stockStatus),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.clearFilters();
                          Navigator.pop(context);
                        },
                        style: ButtonStyles.smallDialogBackButton(context),
                        child: const Text("Clear All"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.applyFilters();
                          Navigator.pop(context);
                        },
                        style: ButtonStyles.smallDialogNextButton(context),
                        child: const Text("Apply Filters"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
