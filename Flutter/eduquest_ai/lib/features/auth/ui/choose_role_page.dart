import 'dart:ui';
import 'package:eduquest_ai/core/helper/shared_pref_helper.dart';
import 'package:eduquest_ai/core/networking/api_constants.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:flutter/material.dart';

enum UserRole { instructor, student }

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0E1A2F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Choose Your Role",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Select how you'll be using Lexis AI today.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 32),
                _RoleCard(
                  title: "Instructor",
                  description: "Manage courses, upload materials, and get real-time AI validation.",
                  icon: Icons.present_to_all_rounded,
                  color: const Color(0xFF8B5CF6),
                  selected: selectedRole == UserRole.instructor,
                  onTap: () {
                    setState(() {
                      selectedRole = UserRole.instructor;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _RoleCard(
                  title: "Student",
                  description: "Join live sessions, gain XP, and ask AI-filtered questions.",
                  icon: Icons.school_rounded,
                  color: const Color(0xFF22D3EE),
                  selected: selectedRole == UserRole.student,
                  onTap: () {
                    setState(() {
                      selectedRole = UserRole.student;
                    });
                  },
                ),
                const Spacer(),
                _ContinueButton(
                  enabled: selectedRole != null,
                  onPressed: selectedRole == null
                      ? null
                      : () async {
                          //! SaveToken
                          SharedPrefHelper.setData(SharedPrefKeys.userRole, selectedRole!.name);
                          String? role = await SharedPrefHelper.getString(SharedPrefKeys.userRole);
                          debugPrint("UserRole: $role");
                          if (!mounted) return;

                          if (role == UserRole.instructor.name) {
                            Navigator.pushReplacementNamed(context, Routes.instructorNavbar);
                          } else {
                            Navigator.pushReplacementNamed(context, Routes.instructorNavbar);
                          }
                        },
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: "Need help? ",
                      style: TextStyle(color: Colors.white54),
                      children: [
                        TextSpan(
                          text: "Contact support",
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selected ? color.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected ? color : Colors.white10,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;

  const _ContinueButton({
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? const Color(0xFF1F2937) : Colors.white10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: enabled ? 10 : 0,
        ),
        child: Text(
          "Continue",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: enabled ? Colors.white : Colors.white38,
          ),
        ),
      ),
    );
  }
}
