import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF006B6B), // Deep Teal
  secondaryHeaderColor: const Color(0xFF004B4B), // Deep Ocean
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF163238), // Navy Black
  cardColor: const Color(0xFF004B4B), // Deep Ocean
  hintColor: const Color(0xFF64777D), // Slate
  focusColor: const Color(0xFF007C91), // Ocean Blue
  canvasColor: const Color(0xFF004B4B),
  shadowColor: Colors.black.withValues(alpha: 0.4),
  textTheme: TextTheme(titleLarge: TextStyle(color: const Color(0xFFFFFDF7).withValues(alpha: 0.9))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF004B4B), surfaceTintColor: Color(0xFF004B4B)),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF006B6B), // Deep Teal
    onPrimary: Colors.white,
    secondary: const Color(0xFF007C91), // Ocean Blue
    onSecondary: const Color(0xFF004B4B), // Deep Ocean
    tertiary: const Color(0xFFE5A900), // Mustard Yellow
    error: const Color(0xFFD94B4B), // Coral Red
    onError: Colors.white,
    surface: const Color(0xFF004B4B),
    onSurface: const Color(0xFFFFFDF7),
    shadow: Colors.black.withValues(alpha: 0.4),
  ),
);
