import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class DropdownFieldWidget extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const DropdownFieldWidget({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final String? effectiveValue =
        items.contains(value) ? value : null;
    return DropdownButtonFormField<String>(
      initialValue: effectiveValue,
      isExpanded: true,
      dropdownColor: ColourStyles.primaryColor,
      hint: const Text("Select from menu"),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColourStyles.primaryColor_2,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColourStyles.primaryColor_2,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColourStyles.colorRed,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColourStyles.colorRed,
            width: 2,
          ),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
