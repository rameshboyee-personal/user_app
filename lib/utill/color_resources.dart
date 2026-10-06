import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF64777D) : const Color(0xFFE2E9EA);
  }

  static Color getDarkColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF004B4B) : const Color(0xFF163238);
  }

  static Color getFooterTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFFFFDF7) : const Color(0xFF64777D);
  }

  static Color getGreyLightColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF64777D) : const Color(0xFFE2E9EA);
  }

  static Color getCategoryBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF004B4B) : const Color(0xFFEAF6F5);
  }

  static Color getAppBarHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF004B4B) : const Color(0xFFEAF6F5);
  }

  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF004B4B) : const Color(0xFFEAF6F5);
  }

  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF004B4B) : const Color(0xFFEAF6F5);
  }

  // Updated palette constant tokens
  static const Color primaryDeepTeal = Color(0xFF006B6B);
  static const Color primaryDarkOcean = Color(0xFF004B4B);
  static const Color secondaryOceanBlue = Color(0xFF007C91);
  static const Color accentMustardYellow = Color(0xFFE5A900);
  static const Color backgroundWarmCream = Color(0xFFFFFDF7);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color lightSectionSoftTeal = Color(0xFFEAF6F5);
  static const Color mainTextNavyBlack = Color(0xFF163238);
  static const Color secondaryTextSlate = Color(0xFF64777D);
  static const Color borderLightGrey = Color(0xFFE2E9EA);

  static const Color cartShadowColor = Color(0xFFE2E9EA);
  static const Color ratingColor = Color(0xFFE5A900);
  static const Color colorGreen = Color(0xFF238636);
  static const Color colorBlue = Color(0xFF007C91);
  static const Color redColor = Color(0xFFD94B4B);
}
