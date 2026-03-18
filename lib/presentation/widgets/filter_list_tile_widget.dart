import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Reusable list tile used in filter lists
class FilterListTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FilterListTileWidget({
    super.key,
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Slight shadow for elevation
      elevation: 2,
      color: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.cardHeading(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: ColourStyles.primaryColor_2,
              onPressed: onEdit,
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: ColourStyles.colorRed,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
