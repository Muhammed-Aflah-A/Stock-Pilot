import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// A reusable widget that represents a single sort option row
class SortOptionTileWidget extends StatelessWidget {
  const SortOptionTileWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Clickable row for the sort option
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // Sort option text
                Expanded(
                  child: Text(label, style: TextStyles.primaryText(context)),
                ),
                // Custom radio-style selection indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Border changes when selected
                    border: Border.all(
                      color: selected
                          ? ColourStyles.primaryColor_2
                          : ColourStyles.borderColor,
                      width: selected ? 2 : 1.5,
                    ),
                  ),
                  // Inner filled circle shown when selected
                  child: selected
                      ? const Center(
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: ColourStyles.primaryColor_2,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1, color: ColourStyles.borderColor),
      ],
    );
  }
}
