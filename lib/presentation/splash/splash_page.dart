import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/auth/bloc/auth_bloc.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            AutoRouter.of(context).replace(
              const NotesOverviewPageRoute(),
            );
          },
          unauthenticated: (_) {
            AutoRouter.of(context).replace(
              const SignInPageRoute(),
            );
          },
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
