import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hestia/features/core/controllers/chatbot_controller.dart';
import 'package:hestia/utils/helpers/helper_function.dart';

class CustomMessage extends StatelessWidget {
  const CustomMessage({
    Key? key,
    required this.text,
    required this.role,
    this.animate = false,
    this.mapIndex, // Stop the Repeating animation when we come back from other screen
  }) : super(key: key);

  final String text;
  final String role;
  final bool animate;
  final int? mapIndex;

  @override
  Widget build(BuildContext context) {
    var dark = MyAppHelperFunctions.isDarkMode(context);
    if (animate) {
      ChatBotController.instance.msgList.value[mapIndex!][2] =
          "No"; // Making No so that next time it doesn't animate
    }
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints: BoxConstraints(
          maxWidth: MyAppHelperFunctions.screenWidth() * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: role == "u" ? Colors.greenAccent : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5),
        ),
        child: !animate
            ? Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              )

            // Msg Typing Effect for the ChatBot Response
            : AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(text,
                      textStyle: const TextStyle(color: Colors.black),
                      cursor: "|",
                      speed: const Duration(milliseconds: 35)),
                ],
                isRepeatingAnimation: false,
              ));
  }
}
