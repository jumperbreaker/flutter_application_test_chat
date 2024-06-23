import 'package:flutter/material.dart';

class AppColors {
  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static  Color tileChat = _colorFromHex('#2B333E');
  static  Color customGrey1 = _colorFromHex('#EDF2F6');
  static  Color lastMessage = _colorFromHex('#5E7A90');
  static  Color prefix = _colorFromHex('#2B333E');
  static  Color sentMessage = _colorFromHex('#00521C');
  static  Color sentMessageBackground = _colorFromHex('#3CED78');
  static  Color receivedMessage = _colorFromHex('#2B333E');  
  static  Color sentMessageDeliveredStatus = _colorFromHex('#00521C');
  static  Color sentMessageReadStatus = _colorFromHex('#34B7F1');  
  static  Color dateDividerColor = _colorFromHex('#9DB7CB');
  static  Color black = _colorFromHex('#000000');  
}
