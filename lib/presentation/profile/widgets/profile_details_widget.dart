import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final List<dynamic> items;
  final Future<void> Function(String fieldType, String value) onSave;

  const ProfileDetailsWidget({
    super.key,
    required this.items,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalSpacing = (size.height * 0.015).clamp(8.0, 18.0);
    final iconBoxSize = (size.width * 0.12).clamp(40.0, 50.0);
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, _) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => SizedBox(height: verticalSpacing),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
              ),
              leading: Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: ColourStyles.selectionColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: item.leadingIcon),
              ),
              title: Text(
                item.title,
                style: TextStyles.titleText(context),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: item.trailingIcon!,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => EditDetailsWidget(
                      title: item.title,
                      initialValue: item.subtitle,
                      fieldtype: item.feildtype,
                      screenWidth: size.width,
                      isEditing: true,
                      onSave: (value) => onSave(item.feildtype, value),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
