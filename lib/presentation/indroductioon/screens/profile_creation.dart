import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/presentation/Dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/indroductioon/viewmodel/profile_creation_provider.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final profileForm = context.watch<ProfileCreationProvider>();
    final drawerProvider = context.watch<DrawerProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.backButtonColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.05),
              Text("Get Started!", style: TextStyles.heading),
              Text(
                "Create a profile to manage inventory",
                style: TextStyles.caption_3,
              ),
              SizedBox(height: h * 0.05),
              Form(
                key: profileForm.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        value = value?.trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        if (value.length < 3) {
                          return "Name must be at least 3 characters";
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
                        value = value.replaceAll("  ", " ");
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.fullName = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.shopNameFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      focusNode: profileForm.shopNameFocus,
                      decoration: InputDecoration(
                        labelText: "Shop Name",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
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
                        profileForm.shopName = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.shopAdressFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      focusNode: profileForm.shopAdressFocus,
                      decoration: InputDecoration(
                        labelText: "Shop Adress",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
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
                        profileForm.shopAdress = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.phoneNumberFocus);
                      },
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      focusNode: profileForm.phoneNumberFocus,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyles.formLabel,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
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
                        profileForm.phoneNumber = newValue;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(
                          context,
                        ).requestFocus(profileForm.emailFocus);
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
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColourStyles.formborderColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        value = value?.replaceAll(" ", "");
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a gmail";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Please enter a valid gmail";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        profileForm.gmail = newValue;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.1),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (profileForm.formKey.currentState!.validate()) {
                          profileForm.formKey.currentState!.save();
                          final user = UserProfile(
                            fullName: profileForm.fullName,
                            shopName: profileForm.shopName,
                            shopAdress: profileForm.shopAdress,
                            gmail: profileForm.gmail,
                            phoneNumber: profileForm.phoneNumber,
                          );
                          await profileForm.addUser(user);
                          drawerProvider.selectedDrawerItem(1);
                          context.read<DrawerProvider>().loadUser();
                          profileForm.formKey.currentState!.reset();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/dashboard',
                            (route) => false,
                          );
                        }
                      },
                      style: ButtonStyles.primaryButton,
                      child: Text(
                        "Create Profile",
                        style: TextStyles.primaryButtonText,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Text("Manage your inventory", style: TextStyles.caption_2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
