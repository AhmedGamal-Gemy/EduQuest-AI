import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(), // OnboardingScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
          /* BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const Scaffold(),//const LoginScreen(),
          ),*/
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
          /* BlocProvider(
            create: (context) => getIt<SignupCubit>(),
            child: const SignupScreen(),
          ),*/
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
          /*BlocProvider(
            create: (context) => HomeCubit(getIt())..getSpecializations(),
            child: const HomeScreen(),
          ),*/
        );
      default:
        return null; //Todo: 404
    }
  }
}
