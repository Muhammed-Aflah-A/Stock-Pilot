import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/presentation/indroductioon/viewmodel/profile_creation_provider.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    final profileForm = context.watch<ProfileCreationProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.backButtonColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text("Get Started!", style: TextStyles.heading),
              Text(
                "Create a profile to manage inventory",
                style: TextStyles.caption_3,
              ),
              SizedBox(height: 80),
              Form(
                key: profileForm.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "First Name",
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
                              value = value?.replaceAll("  ", " ").trim();
                              if (value == null || value.isEmpty) {
                                return "Please enter a First Name";
                              }
                              if (value.length < 3) {
                                return "Name contains least 3 char";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              profileForm.firstName = newValue;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(
                                context,
                              ).requestFocus(profileForm.lastNameFocus);
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            focusNode: profileForm.lastNameFocus,
                            decoration: InputDecoration(
                              labelText: "Last Name",
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
                              value = value?.replaceAll("  ", " ").trim();
                              if (value == null || value.isEmpty) {
                                return "Please enter a Last Name";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              profileForm.lastName = newValue;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(
                                context,
                              ).requestFocus(profileForm.shopNameFocus);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                        value = value?.replaceAll("  ", " ").trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter you shop name";
                        }
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
                    SizedBox(height: 20),
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
                        value = value?.replaceAll("  ", " ").trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter your shop adress";
                        }
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
                    SizedBox(height: 20),
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
                        value = value?.replaceAll(" ", "").trim();
                        if (value == null || value.isEmpty) {
                          return "Please enter a phone number";
                        }
                        if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
                          return "Ph no: at least 10 number long (digits only)";
                        }
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
                    SizedBox(height: 20),
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
              SizedBox(height: 80),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (profileForm.formKey.currentState!.validate()) {
                          profileForm.formKey.currentState!.save();
                          final user = UserProfile(
                            firstName: profileForm.firstName,
                            lastName: profileForm.lastName,
                            shopName: profileForm.shopName,
                            shopAdress: profileForm.shopAdress,
                            gmail: profileForm.gmail,
                            phoneNumber: profileForm.phoneNumber,
                          );
                          await profileForm.addUser(user);
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
                    SizedBox(height: 10),
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
