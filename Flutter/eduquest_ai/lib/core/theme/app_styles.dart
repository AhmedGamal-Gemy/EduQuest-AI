import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );

  static BoxDecoration bgDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.bgGradient,
    ),
  );

  static lightnessShadow(context) => BoxShadow(
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.4),
        blurRadius: 20,
      );
}

class FontWeightHelper {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}
