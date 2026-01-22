import 'package:flutter/material.dart';

class AppColors {
  // Dark Modern Color Scheme
  static const primary = Color(0xFFFF6B35);
  static const primaryLight = Color(0xFFFFB86D);
  static const primaryDark = Color(0xFFE55A2B);
  static const primaryGradientEnd = Color(0xFFFF8E5F);
  
  static const secondary = Color(0xFF1A1A2E);
  static const secondaryLight = Color(0xFF2D2D44);
  static const secondaryDark = Color(0xFF0F0F1E);
  
  static const accent = Color(0xFF00BCD4);
  static const accentLight = Color(0xFF4DD0E1);
  
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFEF5350);
  static const errorLight = Color(0xFFEF5350);
  
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF888888);
  static const greyLight = Color(0xFF3A3A4A);
  static const greyDark = Color(0xFF1A1A2E);
  static const greyMedium = Color(0xFF555555);
  static const darkBg = Color(0xFF0F0F1E);
  static const darkCard = Color(0xFF1A1A2E);
  
  static const background = Color(0xFF0F0F1E);
  static const surface = Color(0xFF1A1A2E);
  
  static const rating = Color(0xFFFFB800);
}

class AppTypography {
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFFDDDDDD),
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    height: 1.3,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double circle = 50;
}
