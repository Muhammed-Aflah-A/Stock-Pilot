import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedtextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Duration speed;
  const AnimatedtextWidget({
    super.key,
    required this.text,
    required this.textStyle,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(text, textStyle: textStyle, speed: speed),
      ],
      totalRepeatCount: 1,
      pause: Duration(seconds: 1),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
