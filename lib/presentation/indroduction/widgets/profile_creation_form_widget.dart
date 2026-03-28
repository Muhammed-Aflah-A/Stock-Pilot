import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/presentation/indroduction/view_model/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

// Widget responsible for rendering the profile creation form.
class ProfileCreationFormWidget extends StatelessWidget {
  const ProfileCreationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive spacing
    final size = MediaQuery.of(context).size;
    // Access provider without listening for rebuilds
    final profileForm = context.read<ProfileCreationProvider>();
    // Dynamic spacing between form fields
    final double fieldGap = (size.height * 0.025).clamp(10.0, 18.0);
    return Form(
      // Form key used for validation and saving form data
      key: profileForm.formKey,
      child: Column(
        children: [
          // Full name feild
          FormWidget(
            labelText: "Full Name",
            maxlength: 25,
            keyboard: KeyboardTypeUtil.getKeyboardType("name"),
            action: TextInputAction.next,
            // Validation handled by external validator utility
            validator: (value) => SelectValidatorUtil.validate(value, "name"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setFullName(value);
            },
            // Move focus to next field (phone number)
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.personalNumberFocus),
          ),
          SizedBox(height: fieldGap),
          // Phone number feild
          FormWidget(
            focus: profileForm.personalNumberFocus,
            labelText: "Phone Number",
            hintText: "+[CountryCode][Number]",
            maxlength: 15,
            keyboard: KeyboardTypeUtil.getKeyboardType("phone number"),
            action: TextInputAction.next,
            // Validation handled by external validator utility
            validator: (value) =>
                SelectValidatorUtil.validate(value, "phone number"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setPersonalNumber(value);
            },
            // Move focus to next field (shop name)
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(profileForm.shopNameFocus),
          ),
          SizedBox(height: fieldGap),
          // Shop name feild
          FormWidget(
            focus: profileForm.shopNameFocus,
            labelText: "Shop Name",
            maxlength: 25,
            keyboard: KeyboardTypeUtil.getKeyboardType("shop name"),
            action: TextInputAction.next,
            // Validation handled by external validator utility
            validator: (value) =>
                SelectValidatorUtil.validate(value, "shop name"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setShopName(value);
            },
            // Move focus to next field (shop address)
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.shopAddressFocus),
          ),
          SizedBox(height: fieldGap),
          // Shop address feild
          FormWidget(
            focus: profileForm.shopAddressFocus,
            labelText: "Shop Address",
            maxlength: 250,
            keyboard: KeyboardTypeUtil.getKeyboardType("shop address"),
            action: TextInputAction.next,
            // Validation handled by external validator utilityne,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "shop address"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setShopAddress(value);
            },
            // Move focus to next field (shop phone number)
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(profileForm.shopNumberFocus),
          ),
          SizedBox(height: fieldGap),
          // Shop phone number feild
          FormWidget(
            focus: profileForm.shopNumberFocus,
            labelText: "Shop's Phone Number",
            hintText: "+[CountryCode][Number]",
            maxlength: 15,
            keyboard: KeyboardTypeUtil.getKeyboardType("phone number"),
            action: TextInputAction.next,
            // Validation handled by external validator utility
            validator: (value) =>
                SelectValidatorUtil.validate(value, "phone number"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setShopNumber(value);
            },
            // Move focus to next field (email address)
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(profileForm.emailFocus),
          ),
          SizedBox(height: fieldGap),
          // email address field
          FormWidget(
            focus: profileForm.emailFocus,
            labelText: "Email Address",
            maxlength: 100,
            keyboard: KeyboardTypeUtil.getKeyboardType("email"),
            action: TextInputAction.done,
            // Validation handled by external validator utility
            validator: (value) => SelectValidatorUtil.validate(value, "email"),
            // Save value to provider
            onSaved: (value) {
              profileForm.setGmail(value);
            },
            // Unfocus from the field
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
