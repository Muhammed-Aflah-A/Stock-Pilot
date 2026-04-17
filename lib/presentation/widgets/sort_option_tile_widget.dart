import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

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
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(label, style: TextStyles.primaryText(context)),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? ColourStyles.primaryColor_2
                          : ColourStyles.borderColor,
                      width: selected ? 2 : 1.5,
                    ),
                  ),
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

