import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/ui/auth_page.dart';
import 'package:eduquest_ai/features/instructor/instructor_navbar.dart';
import 'package:eduquest_ai/features/student/student_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      // case Routes.onBoardingScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const Scaffold(), // OnboardingScreen(),
      //   );

      // case Routes.authScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => getIt<AuthCubit>(),
      //       child: const AuthPage2(), //const LoginScreen(),
      //     ),
      //   );

      // case Routes.signUpScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const Scaffold(),
      //     /* BlocProvider(
      //       create: (context) => getIt<SignupCubit>(),
      //       child: const SignupScreen(),
      //     ),*/
      //   );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
          /*BlocProvider(
            create: (context) => HomeCubit(getIt())..getSpecializations(),
            child: const HomeScreen(),
          ),*/
        );
      case Routes.instructorNavbar:
        return MaterialPageRoute(
          builder: (_) => const InstructorNavbar(),
          /*BlocProvider(
            create: (context) => HomeCubit(getIt())..getSpecializations(),
            child: const HomeScreen(),
          ),*/
        );
      case Routes.studentNavbar:
        return MaterialPageRoute(
          builder: (_) => const StudentNavbar(),
          /*BlocProvider(
            create: (context) => HomeCubit(getIt())..getSpecializations(),
            child: const HomeScreen(),
          ),*/
        );
      default:
        return null; //Todo: 404_page.... from
    }
  }
}
