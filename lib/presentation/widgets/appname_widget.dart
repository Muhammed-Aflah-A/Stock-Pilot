import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class AppnameWidget extends StatelessWidget {
  const AppnameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Stock", style: TextStyles.stroke),

              WidgetSpan(child: SizedBox(width: h * 0.01)),
              TextSpan(text: "Pilot", style: TextStyles.stroke),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Stock", style: TextStyles.stockText),
              WidgetSpan(child: SizedBox(width: h * 0.01)),
              TextSpan(text: "Pilot", style: TextStyles.pilotText),
            ],
          ),
        ),
      ],
    );
  }
}
