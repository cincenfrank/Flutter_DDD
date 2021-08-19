import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/auth/bloc/auth_bloc.dart';
import 'package:resolly/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
        builder: (context, state) {
      return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const Text(
                '🎗',
                style: TextStyle(fontSize: 130),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefix: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.emailChanged(value)),
                validator: (_) => context
                    .read<SignInFormBloc>()
                    .state
                    .emailAddress
                    .value
                    .fold(
                        (f) => f.maybeMap(
                              invalidEmail: (_) => 'Invalid Email',
                              orElse: () => null,
                            ),
                        (r) => null),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefix: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) =>
                    context.read<SignInFormBloc>().state.password.value.fold(
                        (f) => f.maybeMap(
                              shortPassword: (_) => 'Short Password',
                              orElse: () => null,
                            ),
                        (r) => null),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .signInWithEmailAndPasswordPressed(),
                            );
                      },
                      child: const Text('Sign in'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed(),
                            );
                      },
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(
                        const SignInFormEvent.signInWithGooglePressed(),
                      );
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    primary: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                child: const Text('Sign in With Google'),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ]
            ],
          ));
    }, listener: (context, state) {
      state.authFailureOrSuccessOption.fold(
        () {},
        (either) => either.fold((failure) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.map(
                cancelledByUser: (_) => 'cancelledByUser',
                serverError: (_) => 'serverError',
                emailAlreadyInUse: (_) => 'emailAlreadyInUse',
                invalidEmailAndPasswordCombintion: (_) =>
                    'invalidEmailAndPasswordCombintion',
              )),
            ),
          );
        }, (_) {
          AutoRouter.of(context).replace(
            const NotesOverviewPageRoute(),
          );
          context.read<AuthBloc>().add(
                const AuthEvent.authCheckRequested(),
              );
        }),
      );
    });
  }
}
