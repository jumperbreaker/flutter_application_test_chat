// 
import 'package:flutter/material.dart';

class TextTitleChat extends StatelessWidget {
  final String text;

  const TextTitleChat(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        height: 1.225, // line-height: 39.2px
        color: Color(0xFF2B333E),
      ),
      textAlign: TextAlign.center,
    );
  }
}
