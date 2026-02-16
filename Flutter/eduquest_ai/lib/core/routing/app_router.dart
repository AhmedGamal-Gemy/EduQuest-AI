import 'package:eduquest_ai/core/helper/constants.dart';
import 'package:eduquest_ai/core/routing/routes.dart';
import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:eduquest_ai/features/auth/ui/auth_page.dart';
import 'package:eduquest_ai/features/auth/ui/splash_page.dart';
// import 'package:eduquest_ai/features/course/ui/instructor_course_page.dart';
// import 'package:eduquest_ai/features/course/ui/student_course_page.dart';
import 'package:eduquest_ai/app_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loadingScreen:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ); //Todo: loading page.... from
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        ); //Todo: loading page.... from
      case Routes.authScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: const AuthPage(),
          ),
        );

      // case Routes.chooseRole:
      //   return MaterialPageRoute(
      //     builder: (_) => const ChooseRolePage(),
      //   );

      case Routes.appNavigationBar:
        final role = settings.arguments as Role;
        return MaterialPageRoute(
          builder: (_) => AppNavigationBar(role: role),
        );

      default:
        return null; //Todo: 404_page.... from
    }
  }
}
/*
Navigator.pushNamed(
  context,
  Routes.instructorNavbar,
  arguments: Role.instructor, // <-- pass the Role here
);
 */
