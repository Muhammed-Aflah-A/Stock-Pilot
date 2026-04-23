import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/sort_option_tile_widget.dart';

class SortBottomSheetWidget<T> extends StatelessWidget {
  const SortBottomSheetWidget({
    super.key,
    required this.options,
    required this.currentValue,
    required this.defaultValue,
    required this.onSelected,
  });

  final Map<T, String> options;
  final T currentValue;
  final T defaultValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    T tempValue = currentValue;
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          color: ColourStyles.shadowColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: ColourStyles.primaryColor,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close, size: 22),
                            ),
                          ),
                          Text(
                            'Sort Options',
                            style: TextStyles.sectionTitle(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColourStyles.shadowColor),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: options.entries.map((entry) {
                            final isSelected = tempValue == entry.key;
                            return SortOptionTileWidget(
                              label: entry.value,
                              selected: isSelected,
                              onTap: () {
                                setModalState(() {
                                  tempValue = entry.key;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onSelected(defaultValue);
                                Navigator.pop(context);
                              },
                              style: ButtonStyles.smallDialogBackButton(
                                context,
                              ),
                              child: const Text('Clear Sort'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onSelected(tempValue);
                                Navigator.pop(context);
                              },
                              style: ButtonStyles.smallDialogNextButton(
                                context,
                              ),
                              child: const Text('Apply Sort'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
