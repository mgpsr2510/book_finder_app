import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && 
           MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768; // Web is 768px and above
  }

  static double getResponsiveWidth(BuildContext context, {
    double mobile = 1.0,
    double tablet = 0.8,
    double desktop = 0.6,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static int getCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1; // Mobile: 1 card per row
    if (isWeb(context)) return 3; // Web: 3 cards per row
    return 2; // Tablet: 2 cards per row
  }

  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth - 32; // Mobile: full width minus padding
    if (isWeb(context)) return (screenWidth - 64) / 3; // Web: 3 cards per row
    if (isTablet(context)) return (screenWidth - 48) / 2; // Tablet: 2 cards per row
    return (screenWidth - 64) / 3; // Desktop: 3 cards per row
  }

  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16); // Mobile padding
    if (isWeb(context)) return const EdgeInsets.symmetric(horizontal: 30, vertical: 16); // Web: 30px horizontal, 16px vertical
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 30, vertical: 16); // Tablet: 30px horizontal, 16px vertical
    return const EdgeInsets.all(32); // Desktop padding
  }

  static double getMaxWidth(BuildContext context) {
    if (isWeb(context)) return MediaQuery.of(context).size.width; // Web same as mobile
    return MediaQuery.of(context).size.width;
  }
}
