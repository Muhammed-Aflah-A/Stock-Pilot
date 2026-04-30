import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/user_profile_details_model.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';
import 'package:stock_pilot/presentation/widgets/edit_details_widget.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final List<UserProfileDetailsModel> items;

  const ProfileDetailsWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalSpacing = (size.height * 0.015).clamp(8.0, 18.0);
    final iconBoxSize = (size.width * 0.12).clamp(40.0, 50.0);
    final profileForm = context.read<ProfilePageProvider>();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => SizedBox(height: verticalSpacing),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          leading: Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: ColourStyles.selectionColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(item.leadingIcon, color: ColourStyles.primaryColor_2),
            ),
          ),
          title: Text(
            item.title!,
            style: TextStyles.titleText(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            item.subtitle!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(item.trailingIcon, color: ColourStyles.primaryColor_2),
            onPressed: () {
              int? maxLength;
              switch (item.feildtype?.toLowerCase()) {
                case 'name':
                case 'shop name':
                  maxLength = 30;
                  break;
                case 'email':
                  maxLength = 254;
                  break;
                case 'shop address':
                case 'address':
                  maxLength = 100;
                  break;
                case 'phone number':
                case 'personal number':
                case 'shop number':
                  maxLength = 15;
                  break;
              }
              showDialog(
                context: context,
                builder: (_) => EditDetailsWidget(
                  title: item.title!,
                  initialValue: item.subtitle,
                  fieldType: item.feildtype!,
                  maxLength: maxLength,
                  isEditing: true,
                  onSave: (value) async {
                    await profileForm.updateProfile(item.feildtype!, value);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
