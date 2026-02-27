import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class FilterbuttonWidget extends StatelessWidget {
  final FilterProviderInterface provider;

  const FilterbuttonWidget({super.key, required this.provider});

  void _openSheet(BuildContext context) {
    provider.initTempFilters();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = (size.width * 0.12).clamp(40.0, 52.0);

    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final active = provider.hasActiveFilters;
        return SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openSheet(context),
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: active ? Colors.black : Colors.transparent,
                      border: Border.all(
                        color: active
                            ? Colors.black
                            : ColourStyles.primaryColor_2,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      size: (buttonSize * 0.45).clamp(18.0, 24.0),
                      color: active
                          ? Colors.white
                          : ColourStyles.primaryColor_2,
                    ),
                  ),
                  if (active)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  final FilterProviderInterface provider;

  const _FilterBottomSheet({required this.provider});

  static const List<String> _stockOptions = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hPad = (size.width * 0.05).clamp(16.0, 28.0);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListenableBuilder(
                  listenable: provider,
                  builder: (context, _) {
                    final double effectiveMax = provider.maxPrice > 0
                        ? provider.maxPrice
                        : 5000.0;
                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: 16,
                      ),
                      children: [
                        if (provider.categoryList.isNotEmpty) ...[
                          _SectionTitle(size: size, title: 'Category'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.categoryList.map((cat) {
                              final selected = provider.tempCategories.contains(
                                cat,
                              );
                              return _ChoiceChip(
                                size: size,
                                label: cat,
                                selected: selected,
                                onTap: () => provider.toggleTempCategory(cat),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                        _SectionTitle(size: size, title: 'Price Range'),
                        const SizedBox(height: 4),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 18,
                            ),
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: Colors.grey.shade200,
                            thumbColor: Colors.black,
                            overlayColor: Colors.black12,
                          ),
                          child: Slider(
                            min: 0,
                            max: effectiveMax,
                            value: provider.tempMaxPrice.clamp(0, effectiveMax),
                            onChanged: provider.setTempMaxPrice,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$${provider.tempMaxPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: (size.width * 0.032).clamp(11.0, 14.0),
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (provider.brandsList.isNotEmpty) ...[
                          _SectionTitle(size: size, title: 'Brand'),
                          const SizedBox(height: 10),
                          ...provider.brandsList.map((brand) {
                            final selected = provider.tempBrands.contains(
                              brand,
                            );
                            return _BrandTile(
                              size: size,
                              label: brand,
                              selected: selected,
                              onTap: () => provider.toggleTempBrand(brand),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                        if (provider.showStockFilter) ...[
                          _SectionTitle(size: size, title: 'Stock Status'),
                          const SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio:
                                (size.width / 2 - hPad - 4) /
                                (size.height * 0.055).clamp(40.0, 52.0),
                            children: _stockOptions.map((option) {
                              final selected =
                                  provider.tempStockStatus == option;
                              return GestureDetector(
                                onTap: () =>
                                    provider.setTempStockStatus(option),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.black
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: (size.width * 0.032).clamp(
                                        11.0,
                                        14.0,
                                      ),
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
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
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  12,
                  hPad,
                  12 + MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          provider.clearFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.black87,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: (size.height * 0.018).clamp(12.0, 16.0),
                          ),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: (size.width * 0.035).clamp(13.0, 16.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: (size.height * 0.018).clamp(12.0, 16.0),
                          ),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (size.width * 0.035).clamp(13.0, 16.0),
                          ),
                        ),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final Size size;
  const _SectionTitle({required this.title, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: (size.width * 0.038).clamp(13.0, 16.0),
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Size size;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: (size.width * 0.04).clamp(12.0, 20.0),
          vertical: (size.height * 0.008).clamp(6.0, 10.0),
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.black54 : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check, size: 14, color: Colors.black87),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: (size.width * 0.032).clamp(11.0, 14.0),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Size size;

  const _BrandTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(
          horizontal: (size.width * 0.04).clamp(12.0, 20.0),
          vertical: (size.height * 0.016).clamp(12.0, 18.0),
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.black45 : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: (size.width * 0.035).clamp(12.0, 15.0),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 16, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}
