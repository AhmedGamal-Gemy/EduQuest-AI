// import 'package:eduquest_ai/core/helper/app_regex.dart';
// import 'package:eduquest_ai/core/theme/app_colors.dart';
// import 'package:eduquest_ai/features/auth/data/models/login_request_body.dart';
// import 'package:eduquest_ai/features/auth/data/models/signup_request_body.dart';
// import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
// import 'package:eduquest_ai/features/auth/logic/auth_states.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';

// enum AuthType { signin, signup }

// class AuthPage2 extends StatefulWidget {
//   const AuthPage2({super.key});

//   @override
//   AuthPage2State createState() => AuthPage2State();
// }

// class AuthPage2State extends State<AuthPage2> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   // TextEditingController firstNameController = TextEditingController();//Todo: add
//   // TextEditingController lastNameController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();

//   final formKey = GlobalKey<FormState>();
//   AuthType authType = AuthType.signin;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: AppColors.bgGradient,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               //Todo: ▲ AppScaffold
//               child: Column(
//                 children: [
//                   //Todo :As logo
//                   Container(
//                     width: 72,
//                     height: 72,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF8B5CF6),
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 20)],
//                     ),
//                     child: Center(
//                       child: SvgPicture.asset(
//                         "assets/icons/neurology.svg",
//                         // height: 32,
//                         colorFilter: const ColorFilter.mode(AppColors.whiteSoft, BlendMode.srcIn),
//                         // color: AppColors.whiteSoft,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     "Welcome to EduQuestAI ",
//                     style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                           color: AppColors.whiteSoft,
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                   Text(
//                     (authType == AuthType.signin) ? "Sign in to continue your learning journey." : "Create your account and start learning with us.",
//                     style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                           color: AppColors.graySoft,
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                   const SizedBox(height: 32 * 3),
//                   //Todo: ▲ Glass
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(24),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(color: Colors.white.withOpacity(0.1)),
//                         ),
//                         child: Form(
//                           key: formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if ((authType == AuthType.signup)) const SizedBox(height: 20),
//                               if ((authType == AuthType.signup))
//                                 AppTextField(
//                                   controller: firstNameController,
//                                   hint: "First Name",
//                                   icon: Icons.person_outline,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter your first name';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               if ((authType == AuthType.signup)) const SizedBox(height: 20),
//                               if ((authType == AuthType.signup))
//                                 AppTextField(
//                                   controller: lastNameController,
//                                   hint: "Last Name",
//                                   icon: Icons.person_outline,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter your last name';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               const SizedBox(height: 20),
//                               AppTextField(
//                                 controller: emailController,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
//                                     return 'Please enter a valid email';
//                                   }
//                                   return null;
//                                 },
//                                 hint: "sarah.p@university.edu",
//                                 icon: Icons.email_outlined,
//                               ),
//                               const SizedBox(height: 20),
//                               AppTextField(
//                                 controller: passwordController,
//                                 hint: "Password",
//                                 icon: Icons.lock_outline,
//                                 isObscure: true,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter a valid password';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 24),
//                               AuthButton(
//                                 emailController: emailController,
//                                 passwordController: passwordController,
//                                 firstNameController: firstNameController,
//                                 lastNameController: lastNameController,
//                                 formKey: formKey,
//                                 authType: authType,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         authType = (authType == AuthType.signin) ? AuthType.signup : AuthType.signin;
//                       });
//                       debugPrint("authType: $authType");
//                     },
//                     child: Text(
//                       authType != AuthType.signin ? "Already have an account?" : "Create your account",
//                       style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                             color: AppColors.graySoft,
//                             fontWeight: FontWeight.w600,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0B1220),
//               Color(0xFF111A2E),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   _buildLogo(),
//                   const SizedBox(height: 32),
//                   _buildGlassCard(context),
//                   const SizedBox(height: 24),
//                   const Text(
//                     "POWERED BY LEXIS AI FRAMEWORK",
//                     style: TextStyle(
//                       color: Colors.white38,
//                       fontSize: 12,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo() {
//     return Column(
//       children: [
//         Container(
//           width: 72,
//           height: 72,
//           decoration: BoxDecoration(
//             color: const Color(0xFF8B5CF6),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.4),
//                 blurRadius: 20,
//               )
//             ],
//           ),
//           child: const Center(
//             child: Text(
//               "L",
//               style: TextStyle(
//                 fontSize: 36,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF22D3EE),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           "Lexis AI",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 26,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGlassCard(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Welcome",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Real-time AI validation for high-stakes lectures.",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildLabel("EMAIL ADDRESS"),
//               // _buildTextField(
//               //   hint: "sarah.p@university.edu",
//               //   icon: Icons.mail_outline,
//               // ),
//               // const SizedBox(height: 20),
//               // _buildLabel("PASSWORD"),
//               // _buildTextField(
//               //   hint: "••••••••",
//               //   icon: Icons.lock_outline,
//               //   obscure: true,
//               // ),
//               const SizedBox(height: 28),
//               // _buildAuthButton(),
//               const SizedBox(height: 20),
//               Center(
//                 child: Column(
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "No account?",
//                           style: TextStyle(color: Colors.white54),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Color(0xFF22D3EE),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Color(0xFF22D3EE),
//           fontSize: 12,
//           letterSpacing: 1.5,
//         ),
//       ),
//     );
//   }
// }

// // Todo: at-common-widgets + convert to widget
// class AppTextField extends StatefulWidget {
//   const AppTextField({
//     super.key,
//     required this.hint,
//     required this.icon,
//     this.isObscure = false,
//     this.controller,
//     this.validator,
//   });

//   final String hint;
//   final IconData icon;
//   final bool isObscure;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;

//   @override
//   State<AppTextField> createState() => _AppTextFieldState();
// }

// class _AppTextFieldState extends State<AppTextField> {
//   late bool _isObscure;

//   @override
//   void initState() {
//     super.initState();
//     _isObscure = widget.isObscure;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.whiteSoft.withValues(alpha: 0.06),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: TextFormField(
//         controller: widget.controller,
//         validator: widget.validator,
//         obscureText: _isObscure,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           hintText: widget.hint,
//           hintStyle: const TextStyle(color: Colors.white38),
//           prefixIcon: Icon(widget.icon, color: Colors.white54),
//           suffixIcon: widget.isObscure
//               ? IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _isObscure = !_isObscure;
//                     });
//                   },
//                   icon: Icon(
//                     _isObscure ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.white54,
//                   ),
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Todo: at-common-widgets
// class AuthButton extends StatelessWidget {
//   const AuthButton({
//     super.key,
//     required this.emailController,
//     required this.passwordController,
//     required this.firstNameController,
//     required this.lastNameController,
//     required this.formKey,
//     required this.authType,
//   });
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final TextEditingController firstNameController;
//   final TextEditingController lastNameController;
//   final GlobalKey<FormState> formKey;
//   final AuthType authType;

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit, AuthState>(
//       listenWhen: (previous, current) => current is Error || current is Loading || current is Success,
//       listener: (context, state) {
//         state.whenOrNull(
//           error: (error) {
//             // Todo: dialog
//           },
//           success: (data) {
//             // Todo: dialog... continue for choose your role
//           },
//         );
//       },
//       builder: (context, state) {
//         String text = (authType == AuthType.signin) ? "Sign in" : "Sign up";
//         return state.maybeWhen(
//           loading: () => const _SignInLoadingButton(),
//           success: (data) => _SignInEnabledButton(text: text, onPressed: null),
//           orElse: () => _SignInEnabledButton(
//             text: text,
//             onPressed: () {
//               formKey.currentState!.reset(); //Todo: how reset
//               // emailController = emailController.clear();
//               if (formKey.currentState!.validate()) {
//                 debugPrint("Username: ${emailController.text.trim()} ....... Password: ${passwordController.text.trim()} ");
//                 if (authType == AuthType.signin) {
//                   LoginRequestBody body = LoginRequestBody(
//                     username: emailController.text.trim(),
//                     password: passwordController.text.trim(),
//                   );
//                   BlocProvider.of<AuthCubit>(context).emitLoginStates(body);
//                 } else {
//                   debugPrint("Username: ${emailController.text.trim()} ....... Password: ${passwordController.text.trim()}.... Last: ${lastNameController.text.trim()} ....... First: ${firstNameController.text.trim()}");

//                   SignupRequestBody body = SignupRequestBody(
//                     email: emailController.text.trim(),
//                     password: passwordController.text.trim(),
//                     firstName: firstNameController.text.trim(),
//                     lastName: lastNameController.text.trim(),
//                   );
//                   BlocProvider.of<AuthCubit>(context).emitSignupStates(body);
//                 }
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class _SignInLoadingButton extends StatelessWidget {
//   const _SignInLoadingButton();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF8B5CF6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           elevation: 12,
//           shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
//         ),
//         child: const CupertinoActivityIndicator(),
//       ),
//     );
//   }
// }

// class _SignInEnabledButton extends StatelessWidget {
//   const _SignInEnabledButton({this.onPressed, required this.text});
//   final String text;
//   final VoidCallback? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF8B5CF6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           elevation: 12,
//           shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: AppColors.whiteSoft,
//           ),
//         ),
//       ),
//     );
//   }
// }
