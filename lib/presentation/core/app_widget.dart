import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/auth/bloc/auth_bloc.dart';
import 'package:resolly/injection.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class AppWidget extends StatelessWidget {
  // final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    final _appRouter = getIt<AppRouter>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()
            ..add(
              const AuthEvent.authCheckRequested(),
            ),
        )
      ],
      child: MaterialApp.router(
        title: 'Resolly',
        theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            accentColor: Colors.blueAccent,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue[200],
            ),
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)))),
        debugShowCheckedModeBanner: false,
        routerDelegate: AutoRouterDelegate(_appRouter),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
