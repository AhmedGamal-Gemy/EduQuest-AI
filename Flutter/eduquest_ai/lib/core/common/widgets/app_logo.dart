import 'package:eduquest_ai/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: 72, // size.width * 0.08,
        height: 72, // size.width * 0.08,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [AppStyles.lightnessShadow(context)],
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/icons/neurology.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
