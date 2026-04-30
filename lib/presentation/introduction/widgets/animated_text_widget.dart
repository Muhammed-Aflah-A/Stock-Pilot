import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class AnimatedTextWidget extends StatelessWidget {
  const AnimatedTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Smart Stock, Smooth Business',
          textStyle: TextStyles.splashQuote(context),
          speed: Duration(milliseconds: 100),
        ),
      ],
      totalRepeatCount: 1,
      pause: Duration(seconds: 1),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
