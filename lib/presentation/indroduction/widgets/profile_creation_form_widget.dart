import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/utils/form_validator_util.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

class ProfileCreationFormWidget extends StatelessWidget {
  const ProfileCreationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileForm = context.watch<ProfileCreationProvider>();
    final double fieldGap = (size.height * 0.025).clamp(10.0, 18.0);
    return Form(
      key: profileForm.formKey,
      child: Column(
        children: [
          FormWidget(
            labelText: "Full Name",
            maxlength: 25,
            keyboard: TextInputType.name,
            action: TextInputAction.next,
            validator: (v) => FormValidatorUtil.validateName(v, "Full Name"),
            onSaved: (v) => profileForm.fullName = v?.trim(),
            onFieldSubmitted: kIsWeb
                ? null
                : (_) => FocusScope.of(
                    context,
                  ).requestFocus(profileForm.personalNumberFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: kIsWeb ? null : profileForm.personalNumberFocus,
            labelText: "Phone Number",
            hintText: "+[CountryCode][Number]",
            maxlength: 15,
            keyboard: TextInputType.phone,
            action: TextInputAction.next,
            validator: (v) =>
                FormValidatorUtil.validatePhone(v, "Phone Number"),
            onSaved: (v) => profileForm.personalNumber = v?.trim(),
            onFieldSubmitted: kIsWeb
                ? null
                : (_) => FocusScope.of(
                    context,
                  ).requestFocus(profileForm.shopNameFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: kIsWeb ? null : profileForm.shopNameFocus,
            labelText: "Shop Name",
            maxlength: 25,
            keyboard: TextInputType.text,
            action: TextInputAction.next,
            validator: (v) =>
                FormValidatorUtil.validateShopName(v, "Shop Name"),
            onSaved: (v) => profileForm.shopName = v?.trim(),
            onFieldSubmitted: kIsWeb
                ? null
                : (_) => FocusScope.of(
                    context,
                  ).requestFocus(profileForm.shopAdressFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: kIsWeb ? null : profileForm.shopAdressFocus,
            labelText: "Shop Address",
            maxlength: 250,
            keyboard: TextInputType.multiline,
            action: TextInputAction.newline,
            validator: (v) =>
                FormValidatorUtil.validateAddress(v, "Shop Address"),
            onSaved: (v) => profileForm.shopAdress = v?.trim(),
            onFieldSubmitted: kIsWeb
                ? null
                : (_) => FocusScope.of(
                    context,
                  ).requestFocus(profileForm.shopNumberFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: kIsWeb ? null : profileForm.shopNumberFocus,
            labelText: "Shop's Phone Number",
            hintText: "+[CountryCode][Number]",
            maxlength: 15,
            keyboard: TextInputType.phone,
            action: TextInputAction.next,
            validator: (v) =>
                FormValidatorUtil.validatePhone(v, "Phone Number"),
            onSaved: (v) => profileForm.shopNumber = v?.trim(),
            onFieldSubmitted: kIsWeb
                ? null
                : (_) => FocusScope.of(
                    context,
                  ).requestFocus(profileForm.emailFocus),
          ),
          SizedBox(height: fieldGap),
          FormWidget(
            focus: kIsWeb ? null : profileForm.emailFocus,
            labelText: "Email Address",
            maxlength: 100,
            keyboard: TextInputType.emailAddress,
            action: TextInputAction.done,
            validator: (v) => FormValidatorUtil.validateEmail(v, "Email"),
            onSaved: (v) => profileForm.gmail = v?.trim(),
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
