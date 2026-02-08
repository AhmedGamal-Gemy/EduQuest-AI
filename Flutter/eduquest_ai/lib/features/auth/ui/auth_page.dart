import 'package:flutter/material.dart';
import 'dart:ui';

class AuthPage2 extends StatefulWidget {
  const AuthPage2({super.key});

  @override
  AuthPage2State createState() => AuthPage2State();
}

class AuthPage2State extends State<AuthPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E162A),
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

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
              Color(0xFF111A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 32),
                  _buildGlassCard(context),
                  const SizedBox(height: 24),
                  const Text(
                    "POWERED BY LEXIS AI FRAMEWORK",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
              )
            ],
          ),
          child: const Center(
            child: Text(
              "L",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22D3EE),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Lexis AI",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Real-time AI validation for high-stakes lectures.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel("EMAIL ADDRESS"),
              _buildTextField(
                hint: "sarah.p@university.edu",
                icon: Icons.mail_outline,
              ),
              const SizedBox(height: 20),
              _buildLabel("PASSWORD"),
              _buildTextField(
                hint: "••••••••",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 28),
              _buildSignInButton(),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No account?",
                          style: TextStyle(color: Colors.white54),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF22D3EE),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF22D3EE),
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 12,
          shadowColor: const Color(0xFF8B5CF6).withOpacity(0.6),
        ),
        child: const Text(
          "Sign In",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
