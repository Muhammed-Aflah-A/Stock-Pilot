import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class AppnameWidget extends StatelessWidget {
  const AppnameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Stock", style: TextStyles.stroke(context)),
              WidgetSpan(child: SizedBox(width: screenSize.width * 0.02)),
              TextSpan(text: "Pilot", style: TextStyles.stroke(context)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Stock", style: TextStyles.stockText(context)),
              WidgetSpan(child: SizedBox(width: screenSize.width * 0.02)),
              TextSpan(text: "Pilot", style: TextStyles.pilotText(context)),
            ],
          ),
        ),
      ],
    );
  }
}

