import 'package:flutter/material.dart';

class Constant {
  static const String apiKey = 'b2196be04bee432e9a0175402242806';
  final Color primaryColor = const Color(0xff90B2F9);
  final Color secondaryColor = const Color(0xff90B2F8);
}

class CityConstant {
  final primaryColor = const Color(0xff6b9dfc);
  final secondaryColor = const Color(0xffa1c6fd);
  final tertiaryColor = const Color(0xff205cf1);
  final blackColor = const Color(0xff1a1d26);

  final greyColor = const Color(0xffd9dadb);

  final Shader shader = const LinearGradient(
          colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)])
      .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGredientBlue = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xff6b9dfc), Color(0xff205cf1)],
    stops: [0.0, 1.0],
  );
  final linearGredientPurple = const LinearGradient(
    colors: [
      Color(0xff51087E),
      Color(0xff6C0BA9),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.0,1.0]
  );
}
