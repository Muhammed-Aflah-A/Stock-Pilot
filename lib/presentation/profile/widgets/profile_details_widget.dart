import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final List<dynamic> items;
  final void Function(
    ProfilePageProvider provider,
    String fieldType,
    String value,
  )
  onSave;

  const ProfileDetailsWidget({
    super.key,
    required this.items,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: screenHeight * 0.015),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                constraints: const BoxConstraints(
                  maxWidth: 50,
                  maxHeight: 50,
                  minWidth: 40,
                  minHeight: 40,
                ),
                decoration: BoxDecoration(
                  color: ColourStyles.selectionColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: item.leadingIcon),
              ),
              title: Text(item.title, style: TextStyles.titleText(context)),
              subtitle: Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return EditDetailsWidget(
                      title: item.title,
                      initialValue: item.subtitle,
                      fieldtype: item.feildtype,
                      provider: provider,
                      screenWidth: screenWidth,
                      onSave: onSave,
                    );
                  },
                ),
                icon: item.trailingIcon!,
              ),
            );
          },
        );
      },
    );
  }
}
