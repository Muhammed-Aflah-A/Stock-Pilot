import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/presentation/introduction/view_model/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

class ProfileCreationFormWidget extends StatelessWidget {
  const ProfileCreationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileForm = context.read<ProfileCreationProvider>();
    final double fieldGap = (size.height * 0.025).clamp(10.0, 18.0);
    return Form(
      key: profileForm.formKey,
      child: Column(
        children: [
          FormWidget(
            labelText: "Full Name",
            maxlength: 30,
            keyboard: KeyboardTypeUtil.getKeyboardType("name"),
            action: TextInputAction.next,
            validator: (value) => SelectValidatorUtil.validate(value, "name"),
            onSaved: (value) {
              profileForm.setFullName(value);
            },
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.personalNumberFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: profileForm.personalNumberFocus,
            labelText: "Phone Number",
            hintText: "+911234567890",
            maxlength: 15,
            keyboard: KeyboardTypeUtil.getKeyboardType("phone number"),
            action: TextInputAction.next,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "phone number"),
            onSaved: (value) {
              profileForm.setPersonalNumber(value);
            },
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(profileForm.shopNameFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: profileForm.shopNameFocus,
            labelText: "Shop Name",
            maxlength: 30,
            keyboard: KeyboardTypeUtil.getKeyboardType("shop name"),
            action: TextInputAction.next,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "shop name"),
            onSaved: (value) {
              profileForm.setShopName(value);
            },
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.shopAddressFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: profileForm.shopAddressFocus,
            labelText: "Shop Address",
            maxlength: 100,
            keyboard: KeyboardTypeUtil.getKeyboardType("shop address"),
            action: TextInputAction.next,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "shop address"),
            onSaved: (value) {
              profileForm.setShopAddress(value);
            },
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.shopNumberFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: profileForm.shopNumberFocus,
            labelText: "Shop's Phone Number",
            hintText: "+911234567890",
            maxlength: 15,
            keyboard: KeyboardTypeUtil.getKeyboardType("phone number"),
            action: TextInputAction.next,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "phone number"),
            onSaved: (value) {
              profileForm.setShopNumber(value);
            },
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(profileForm.emailFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: profileForm.emailFocus,
            labelText: "Email Address",
            maxlength: 254,
            keyboard: KeyboardTypeUtil.getKeyboardType("email"),
            action: TextInputAction.done,
            validator: (value) => SelectValidatorUtil.validate(value, "email"),
            onSaved: (value) {
              profileForm.setGmail(value);
            },
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
