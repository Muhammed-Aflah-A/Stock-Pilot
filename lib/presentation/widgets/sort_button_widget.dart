import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/sort_bottom_sheet.dart';

// Button widget that opens the sort bottom sheet.
class SortButtonWidget<T> extends StatelessWidget {
  const SortButtonWidget({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    required this.defaultValue,
  });
  final Map<T, String> options;
  final T currentValue;
  final T defaultValue;
  final ValueChanged<T> onSelected;
  bool get _isActive => currentValue != defaultValue;
  // Opens the sort bottom sheet modal
  void _openSortSheet(BuildContext context) {
    // Dismiss keyboard if any text field is focused
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      // Transparent background allows custom modal styling
      backgroundColor: Colors.transparent,
      // Allows full-height modal if needed
      isScrollControlled: true,
      // Build the sort bottom sheet widget
      builder: (_) => SortBottomSheetWidget<T>(
        options: options,
        currentValue: currentValue,
        defaultValue: defaultValue,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = (size.width * 0.12).clamp(40.0, 52.0);
    return SizedBox(
      width: buttonSize,
      height: 45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSortSheet(context),
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Main button container
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // Background changes when sorting is active
                  color: _isActive
                      ? ColourStyles.primaryColor_2
                      : ColourStyles.primaryColor,
                  border: Border.all(
                    color: ColourStyles.primaryColor_2,
                    width: 1.5,
                  ),
                ),
                // Sort icon
                child: Icon(
                  Icons.sort,
                  size: (buttonSize * 0.45).clamp(18.0, 24.0),
                  // Icon color changes depending on active state
                  color: _isActive
                      ? ColourStyles.primaryColor
                      : ColourStyles.primaryColor_2,
                ),
              ),
              // Small red dot indicator when sort is active
              if (_isActive)
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
  }
}
