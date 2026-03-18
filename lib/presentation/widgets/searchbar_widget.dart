import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Reusable search bar widget
class SearchbarWidget extends StatelessWidget {
  // Controller used to read and control the text field value
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;

  const SearchbarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // Border style reused for enabled and focused states
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: ColourStyles.primaryColor_2,
        width: 1.5,
      ),
    );
    return SizedBox(
      height: 45,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            // Vertically center the text
            textAlignVertical: TextAlignVertical.center,
            // Text style for user input
            style: TextStyles.formHint(
              context,
            ).copyWith(color: ColourStyles.primaryColor_2),
            decoration: InputDecoration(
              hintText: hintText,
              // Hint text style
              hintStyle: TextStyles.formHint(context),
              // Search icon on the left side
              prefixIcon: Icon(Icons.search),
              // Show clear button only when text is not empty
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      // Clears the search text when pressed
                      onPressed: onClear,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: border,
              focusedBorder: border,
              filled: true,
              fillColor: ColourStyles.primaryColor,
            ),
          );
        },
      ),
    );
  }
}
