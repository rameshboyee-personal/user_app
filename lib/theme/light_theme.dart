import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF006B6B), // Deep Teal
  secondaryHeaderColor: const Color(0xFFEAF6F5), // Soft Teal
  brightness: Brightness.light,
  cardColor: const Color(0xFFFFFFFF), // White
  focusColor: const Color(0xFF007C91), // Ocean Blue
  hintColor: const Color(0xFF64777D), // Slate
  canvasColor: const Color(0xFFFFFDF7), // Warm Cream
  scaffoldBackgroundColor: const Color(0xFFFFFDF7), // Warm Cream
  shadowColor: const Color(0xFFE2E9EA), // Light Grey (Border)

  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF163238)), // Navy Black
    bodyLarge: TextStyle(color: Color(0xFF163238)),
    bodyMedium: TextStyle(color: Color(0xFF64777D)),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF006B6B), // Deep Teal
    onPrimary: Colors.white,
    secondary: Color(0xFF007C91), // Ocean Blue
    onSecondary: Color(0xFFEAF6F5), // Soft Teal
    tertiary: Color(0xFFE5A900), // Mustard Yellow (Accent)
    error: Color(0xFFD94B4B), // Coral Red
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF163238), // Navy Black
    shadow: Color(0xFFE2E9EA),
  ),
);