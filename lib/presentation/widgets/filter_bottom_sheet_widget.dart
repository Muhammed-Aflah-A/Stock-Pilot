import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/brand_choice_widget.dart';
import 'package:stock_pilot/presentation/widgets/category_choice_widget.dart';
import 'package:stock_pilot/presentation/widgets/section_title_widget.dart';
import 'package:stock_pilot/presentation/widgets/stock_status_choice_widget.dart';

// Bottom sheet widget used for filtering products
class FilterBottomSheet extends StatelessWidget {
  final FilterProviderInterface provider;
  const FilterBottomSheet({super.key, required this.provider});

  /// Static stock status options
  static const List<String> _stockOptions = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 28.0);
    return DraggableScrollableSheet(
      // Initial height of bottom sheet
      initialChildSize: 0.85,
      // Maximum height user can drag
      maxChildSize: 0.95,
      // Minimum height when dragged down
      minChildSize: 0.4,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ColourStyles.primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle indicator
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
              // Title and close button row
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter title
                    Text('Filter', style: TextStyles.sectionTitle(context)),
                    // Close button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              // Main filter content
              Expanded(
                child: ListenableBuilder(
                  listenable: provider,
                  builder: (context, _) {
                    // Determine max price for slider
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
                        // CATEGORY FILTER
                        if (provider.categoryList.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          // Section title
                          const SectionTitleWidget(title: "Category"),
                          const SizedBox(height: 10),
                          // Category options displayed as chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.categoryList.map((category) {
                              // Check if category is selected
                              final selected = provider.tempCategories.contains(
                                category,
                              );
                              return CategoryChoiceWidget(
                                label: category,
                                selected: selected,
                                onTap: () =>
                                    provider.toggleTempCategory(category),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                        // PRICE RANGE FILTER
                        const SectionTitleWidget(title: "Price Range"),
                        // RangeSlider used to select min/max price
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
                        // Display selected price range
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
                        // BRAND FILTER
                        if (provider.brandsList.isNotEmpty) ...[
                          const SectionTitleWidget(title: "Brand"),
                          const SizedBox(height: 10),
                          ...provider.brandsList.map((brand) {
                            /// Check if brand is selected
                            final selected = provider.tempBrands.contains(
                              brand,
                            );
                            // Brand options displayed
                            return BrandChoiceWidget(
                              label: brand,
                              selected: selected,
                              onTap: () => provider.toggleTempBrand(brand),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                        // STOCK STATUS FILTER
                        if (provider.showStockFilter) ...[
                          const SectionTitleWidget(title: "Stock Status"),
                          const SizedBox(height: 10),
                          // Grid layout for stock options
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 3,
                            children: _stockOptions.map((stockStatus) {
                              // Check if selected
                              final selected =
                                  provider.tempStockStatus == stockStatus;
                              return StockStatusChoiceWidget(
                                label: stockStatus,
                                selected: selected,
                                onTap: () =>
                                    provider.setTempStockStatus(stockStatus),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const Divider(thickness: 1),
              // ACTION BUTTONS (Clear & Apply)
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Row(
                  children: [
                    // Clear all filters
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
                    // Apply filters
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
