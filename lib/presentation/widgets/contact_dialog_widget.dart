import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class ContactDialogWidget extends StatelessWidget {
  const ContactDialogWidget({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ContactDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("Contact & Support", style: TextStyles.titleText(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Need help? Reach out to us via email or visit our website.",
            style: TextStyles.activityCardText(context),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 20,
                color: ColourStyles.primaryColor_2,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "aflahathimannil@gmail.com",
                  style: TextStyles.primaryText(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.language,
                size: 20,
                color: ColourStyles.primaryColor_2,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Coming soon..",
                  style: TextStyles.primaryText(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Close",
            style: TextStyle(color: ColourStyles.primaryColor_2),
          ),
        ),
      ],
    );
  }
}
