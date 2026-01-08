import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/presentation/indroduction/viewmodel/profile_creation_provider.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

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
          FormWidget(
            maxlength: 50,
            keyboard: TextInputType.name,
            labelText: "Full Name",
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
              if (value.length > 25) {
                return "Name cannot be more than 25 characters";
              }
              return null;
            },
            onSaved: (newValue) {
              profileForm.fullName = newValue!.trim();
            },
            action: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(
                context,
              ).requestFocus(profileForm.personalNumberFocus);
            },
          ),
          SizedBox(height: h * 0.005),
          FormWidget(
            focus: profileForm.personalNumberFocus,
            maxlength: 15,
            keyboard: TextInputType.phone,
            labelText: "Phone Number",
            hintText: "Start with country code",
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
            action: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopNameFocus);
            },
          ),
          SizedBox(height: h * 0.005),
          FormWidget(
            focus: profileForm.shopNameFocus,
            maxlength: 25,
            keyboard: TextInputType.name,
            labelText: "Shop Name",
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter you shop name";
              }
              if (RegExp(r'\s{2,}').hasMatch(value)) {
                return "Shop name cannot contain multiple spaces together";
              }
              if (value.length < 3) {
                return "Shop name must be at least 3 characters";
              }
              if (value.length > 25) {
                return "Shop name cannot be more than 25 characters";
              }
              value = value.replaceAll("  ", " ");
              return null;
            },
            onSaved: (newValue) {
              profileForm.shopName = newValue!.trim();
            },
            action: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopAdressFocus);
            },
          ),
          SizedBox(height: h * 0.005),
          FormWidget(
            focus: profileForm.shopAdressFocus,
            maxlength: 250,
            keyboard: TextInputType.multiline,
            labelText: "Shop Address",
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
              if (!RegExp(r'^.{1,250}$').hasMatch(value)) {
                return 'Address must not exceed 250 characters';
              }
              value = value.replaceAll("  ", " ");
              return null;
            },
            onSaved: (newValue) {
              profileForm.shopAdress = newValue!.trim();
            },
            action: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.shopNumberFocus);
            },
          ),
          SizedBox(height: h * 0.005),
          FormWidget(
            focus: profileForm.shopNumberFocus,
            maxlength: 15,
            keyboard: TextInputType.phone,
            labelText: "Shop's Phone Number",
            hintText: "Start with country code",
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
            action: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(profileForm.emailFocus);
            },
          ),
          SizedBox(height: h * 0.005),
          FormWidget(
            focus: profileForm.emailFocus,
            maxlength: 100,
            keyboard: TextInputType.emailAddress,
            labelText: "Email Address",
            validator: (value) {
              value = value?.trim();
              if (value == null || value.isEmpty) {
                return "Please enter a email";
              }
              if (!RegExp(r'^[a-z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                return "Please enter a valid email";
              }
              if (value.length > 100) {
                return "Email cannot be more than 100 characters";
              }
              value = value.replaceAll(" ", "");
              return null;
            },
            onSaved: (newValue) {
              profileForm.gmail = newValue!.trim();
            },
            action: TextInputAction.done,
            onFieldSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
