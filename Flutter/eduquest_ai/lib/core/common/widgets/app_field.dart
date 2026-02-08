import 'package:eduquest_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppField extends StatefulWidget {
  const AppField({
    super.key,
    required this.hint,
    required this.icon,
    this.isObscure = false,
    this.controller,
    this.validator,
  });

  final String hint;
  final IconData icon;
  final bool isObscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSoft.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: _isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(widget.icon, color: Colors.white54),
          suffixIcon: widget.isObscure
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
