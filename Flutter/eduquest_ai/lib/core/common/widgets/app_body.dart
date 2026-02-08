import 'package:eduquest_ai/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key, required this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.bgDecoration,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
