import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';

class ProfileCreationFormWidget extends StatelessWidget {
  const ProfileCreationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final profileForm = context.watch<ProfileCreationProvider>();
    return Form(
      key: profileForm.formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Full Name",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter your full name";
              }
              if (RegExp(r'\d').hasMatch(value)) {
                return "Name cannot contain numbers";
              }
              if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                return "Name cannot contain special characters";
              }
              if (RegExp(r'\s{2,}').hasMatch(value)) {
                return "Name cannot contain multiple spaces together";
              }
              if (value.length < 3) {
                return "Name must be at least 3 characters";
              }
              return null;
            },
            onSaved: (newValue) {
              profileForm.fullName = newValue!.trim();
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(
                context,
              ).requestFocus(profileForm.personalNumberFocus);
            },
          ),
          SizedBox(height: h * 0.02),
          TextFormField(
            focusNode: profileForm.personalNumberFocus,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter a phone number";
              }
              if (!value.startsWith('+')) {
                return "Phone number must start with +";
              }
              if (RegExp(r'\s').hasMatch(value)) {
                return "Phone number must not contain spaces";
              }
              if (!RegExp(r'^\+\d+$').hasMatch(value)) {
                return "Only numbers are allowed after +";
              }
              if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
                return "Enter a valid international phone number";
              }
              value = value.replaceAll(" ", "");
              return null;
            },
            onSaved: (newValue) {
              profileForm.personalNumber = newValue!.trim();
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopNameFocus);
            },
          ),
          SizedBox(height: h * 0.02),
          TextFormField(
            focusNode: profileForm.shopNameFocus,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Shop Name",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter you shop name";
              }
              if (RegExp(r'\s{2,}').hasMatch(value)) {
                return "Shop name cannot contain multiple spaces together";
              }
              value = value.replaceAll("  ", " ");
              return null;
            },
            onSaved: (newValue) {
              profileForm.shopName = newValue!.trim();
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopAdressFocus);
            },
          ),
          SizedBox(height: h * 0.02),
          TextFormField(
            focusNode: profileForm.shopAdressFocus,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Shop Address",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter your shop address";
              }
              if (value.length < 10) {
                return "Shop address must be at least 10 characters";
              }
              if (RegExp(r'\s{2,}').hasMatch(value)) {
                return "Shop address cannot contain multiple spaces together";
              }
              value = value.replaceAll("  ", " ");
              return null;
            },
            onSaved: (newValue) {
              profileForm.shopAdress = newValue!.trim();
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopNumberFocus);
            },
          ),
          SizedBox(height: h * 0.02),
          TextFormField(
            focusNode: profileForm.shopNumberFocus,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Shop's phone Number",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter a phone number";
              }
              if (!value.startsWith('+')) {
                return "Phone number must start with +";
              }
              if (RegExp(r'\s').hasMatch(value)) {
                return "Phone number must not contain spaces";
              }
              if (!RegExp(r'^\+\d+$').hasMatch(value)) {
                return "Only numbers are allowed after +";
              }
              if (!RegExp(r'^\+\d{7,15}$').hasMatch(value)) {
                return "Enter a valid international phone number";
              }
              value = value.replaceAll(" ", "");
              return null;
            },
            onSaved: (newValue) {
              profileForm.shopNumber = newValue!.trim();
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.emailFocus);
            },
          ),
          SizedBox(height: h * 0.02),
          TextFormField(
            focusNode: profileForm.emailFocus,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyles.formLabel,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter a email";
              }
              if (!RegExp(r'^[a-z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                return "Please enter a valid email";
              }
              value = value.replaceAll(" ", "");
              return null;
            },
            onSaved: (newValue) {
              profileForm.gmail = newValue!.trim();
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
