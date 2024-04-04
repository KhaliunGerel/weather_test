import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomColors {
  Color get PRIMARY;
  Color get BACKGROUND_1;
  Color get SURFACE_HIGH;
}

class ColorsLight extends CustomColors {
  @override
  Color PRIMARY = const Color(0xfff6f6f6);
  @override
  Color BACKGROUND_1 = const Color(0xfffcfcfc);
  @override
  Color SURFACE_HIGH = const Color(0xff020202);
}

class ColorsDark extends CustomColors {
  @override
  Color PRIMARY = const Color(0xff00031E);
  @override
  Color BACKGROUND_1 = const Color(0xff030c2a);
  @override
  Color SURFACE_HIGH = const Color(0xfffefefe);
}

CustomColors getThemeColors() => Get.isDarkMode ? ColorsDark() : ColorsLight();
