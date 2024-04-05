import 'dart:ui';

import 'package:flutter/material.dart';

class ColorManager{
  static Color primary = HexColor.fromHex("#ED9728");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryCOlorOpacity = HexColor.fromHex("#B3ED9728");

  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#e61f34");
  static Color mainColor = HexColor.fromHex("#f36c50");

  static Color generateColor(List<Color> colors, {required double opacity}) {

    int red = 0;
    int green = 0;
    int blue = 0;

    for (Color color in colors) {
      red += int.parse(color.red.toRadixString(16), radix: 16);
      green += int.parse(color.green.toRadixString(16), radix: 16);
      blue += int.parse(color.blue.toRadixString(16), radix: 16);
    }

    red = (red ~/ colors.length).clamp(0, 255);
    green = (green ~/ colors.length).clamp(0, 255);
    blue = (blue ~/ colors.length).clamp(0, 255);

    return Color.fromRGBO(red, green, blue, opacity);
  }
}



extension HexColor on Color{
  static Color fromHex(String hexColorString){
    hexColorString = hexColorString.replaceAll("#", '');

    if(hexColorString.length == 6){
      hexColorString = "FF$hexColorString";//8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }

  
}