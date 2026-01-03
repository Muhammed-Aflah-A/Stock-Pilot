import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class EditWidget extends StatelessWidget {
  final List<dynamic> items;
  final void Function(
    ProfilePageProvider provider,
    String fieldType,
    String value,
  )
  onSave;
  const EditWidget({super.key, required this.items, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Consumer<ProfilePageProvider>(
      builder: (context, provider, child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => SizedBox(height: h * 0.01),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ColourStyles.baseBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: item.leadingIcon,
              ),
              title: Text(item.title!),
              subtitle: Text(item.subtitle!),
              trailing: IconButton(
                onPressed: () {
                  final formkey = GlobalKey<FormState>();
                  final controller = TextEditingController(text: item.subtitle);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: ColourStyles.primaryColor,
                        title: Center(
                          child: Text(
                            "Edit ${item.title}",
                            style: TextStyles.heading_2,
                          ),
                        ),
                        content: Form(
                          key: formkey,
                          child: TextFormField(
                            controller: controller,
                            keyboardType: provider.getKeyboardType(
                              item.feildtype!,
                            ),
                            decoration: InputDecoration(
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
                            validator: (value) =>
                                provider.validate(value, item.feildtype!),
                            onSaved: (newValue) {
                              onSave(
                                provider,
                                item.feildtype!,
                                newValue!.trim(),
                              );
                            },
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyles.dialogBackButton_2,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("cancel"),
                              ),
                              SizedBox(width: w * 0.02),
                              ElevatedButton(
                                style: ButtonStyles.dialogNextButton_2,
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    formkey.currentState!.save();
                                    await provider.updateUser();
                                    formkey.currentState!.reset();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text("save"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: item.trailingIcon!,
              ),
            );
          },
        );
      },
    );
  }
}
