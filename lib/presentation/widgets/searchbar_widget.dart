import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class SearchbarWidget extends StatelessWidget {
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
    final size = MediaQuery.of(context).size;
    final height = (size.height * 0.06).clamp(44.0, 56.0);
    return SizedBox(
      height: height,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyles.formHint(
              context,
            ).copyWith(color: ColourStyles.primaryColor_2),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyles.formHint(context),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClear,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: ColourStyles.primaryColor,
            ),
          );
        },
      ),
    );
  }
}
