import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class FilterlistTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FilterlistTileWidget({
    super.key,
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.03).clamp(12.0, 24.0);
    final verticalPadding = (size.height * 0.008).clamp(4.0, 12.0);
    final editIconSize = (size.width * 0.025).clamp(20.0, 28.0);
    final deleteIconSize = (size.width * 0.022).clamp(18.0, 24.0);
    return Card(
      elevation: 2,
      color: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
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
            SizedBox(width: horizontalPadding * 0.5),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.edit_outlined,
                color: ColourStyles.colorGreen,
                size: editIconSize,
              ),
              onPressed: onEdit,
            ),
            SizedBox(width: horizontalPadding * 0.4),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.delete_outline,
                color: ColourStyles.colorRed,
                size: deleteIconSize,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
