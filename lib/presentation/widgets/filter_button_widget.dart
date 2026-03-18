import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/filter_bottom_sheet_widget.dart';

// A button widget that opens the filter bottom sheet
class FilterButtonWidget extends StatelessWidget {
  final FilterProviderInterface provider;
  const FilterButtonWidget({super.key, required this.provider});
  // Opens the filter bottom sheet
  void _openSheet(BuildContext context) {
    // Initialize temporary filters before showing the sheet
    provider.initTempFilters();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = (size.width * 0.12).clamp(40.0, 52.0);
    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        // Check if any filters are currently active
        final active = provider.hasActiveFilters;
        return SizedBox(
          width: buttonSize,
          height: 45,
          child: Material(
            color: ColourStyles.primaryColor,
            child: InkWell(
              onTap: () => _openSheet(context),
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // Change background when filters are active
                      color: active
                          ? ColourStyles.primaryColor_2
                          : ColourStyles.primaryColor,
                      border: Border.all(
                        color: ColourStyles.primaryColor_2,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      size: (buttonSize * 0.45).clamp(18.0, 24.0),
                      // Change icon color depending on filter state
                      color: active
                          ? ColourStyles.primaryColor
                          : ColourStyles.primaryColor_2,
                    ),
                  ),
                  // Small red indicator dot when filters are active
                  if (active)
                    const Positioned(
                      right: 5,
                      top: 5,
                      child: SizedBox(
                        width: 8,
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: ColourStyles.colorRed,
                            shape: BoxShape.circle,
                          ),
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
