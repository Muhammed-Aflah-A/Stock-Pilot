import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/sort_bottom_sheet.dart';

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
  void _openSortSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isActive
                      ? ColourStyles.primaryColor_2
                      : ColourStyles.primaryColor,
                  border: Border.all(
                    color: ColourStyles.primaryColor_2,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.sort,
                  size: (buttonSize * 0.45).clamp(18.0, 24.0),
                  color: _isActive
                      ? ColourStyles.primaryColor
                      : ColourStyles.primaryColor_2,
                ),
              ),
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
