import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
// Uses the `animated_text_kit` package to create this animation
class AnimatedTextWidget extends StatelessWidget {
  const AnimatedTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Smart Stock, Smooth Business',
          textStyle: TextStyles.splashQuote(context),
          // Typing speed
          speed: Duration(milliseconds: 100),
        ),
      ],
      // Play animation only once
      totalRepeatCount: 1,
      // Pause after completion
      pause: Duration(seconds: 1),
      // Instantly show full text when tapped
      displayFullTextOnTap: true,
      // Skip pause when tapped
      stopPauseOnTap: true,
    );
  }
}
