import 'package:eduquest_ai/dependency_injection.dart';
import 'package:eduquest_ai/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorNavbar extends StatelessWidget {
  const InstructorNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Instructor Navbar'),
            ),
            body: Container(),
          );
        },
      ),
    );
  }
}
