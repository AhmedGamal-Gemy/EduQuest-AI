import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // fontFamily: "NaughtyMonster",
    scaffoldBackgroundColor: AppColors.navyBlue,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple,
      onPrimary: AppColors.whiteSoft,
      secondary: AppColors.cyan,
      onSecondary: AppColors.navyDark,
      surface: AppColors.deepBlue,
      onSurface: AppColors.whiteSoft,
      error: Colors.redAccent,
      onError: AppColors.whiteSoft,
    ),
    // Optional: map previous properties to use the ColorScheme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.deepBlue, // use surface
      selectedItemColor: AppColors.purple, // use primary
      unselectedItemColor: AppColors.whiteSoft, // use onSurface
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.navyBlue,
      foregroundColor: AppColors.whiteSoft,
      elevation: 0,
      centerTitle: true,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.purple,
      selectionColor: AppColors.purple.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.purple,
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: AppColors.graySoft,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
      ),
      labelStyle: const TextStyle(
        color: AppColors.graySoft,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w500,
      ),
      // filled: true,
      // fillColor: AppColors.deepBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.grayBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.grayBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.whiteSoft,
        elevation: 12,
        shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
