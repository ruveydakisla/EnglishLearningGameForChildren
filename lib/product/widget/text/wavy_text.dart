import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/color_constants.dart';

class WavyBoldText extends StatelessWidget {
  const WavyBoldText({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 30.0, color: ColorConstants.black),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(title),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          print("Tap Event");
        },
      ),
    );
  }
}
