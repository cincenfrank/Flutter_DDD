// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i6;
import 'package:injectable/injectable.dart' as _i2;

import 'application/auth/bloc/auth_bloc.dart' as _i15;
import 'application/auth/sign_in_form/bloc/sign_in_form_bloc.dart' as _i14;
import 'application/notes/note_actor/note_actor_bloc.dart' as _i11;
import 'application/notes/note_form/note_form_bloc.dart' as _i12;
import 'application/notes/note_watcher/note_watcher_bloc.dart' as _i13;
import 'domain/auth/i_auth_facade.dart' as _i7;
import 'domain/notes/i_note_repository.dart' as _i9;
import 'infrastructure/auth/firebase_auth_facade.dart' as _i8;
import 'infrastructure/core/firebase_injectable_module.dart' as _i17;
import 'infrastructure/notes/note_repository.dart' as _i10;
import 'presentation/routes/app_router.gr.dart' as _i3;
import 'presentation/routes/app_router_injectable_module.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appRouterInjectableModule = _$AppRouterInjectableModule();
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.AppRouter>(() => appRouterInjectableModule.appRouter);
  gh.lazySingleton<_i4.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i5.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore);
  gh.lazySingleton<_i6.GoogleSignIn>(
      () => firebaseInjectableModule.googleSignIn);
  gh.lazySingleton<_i7.IAuthFacade>(() =>
      _i8.FirebaseAuthFacade(get<_i4.FirebaseAuth>(), get<_i6.GoogleSignIn>()));
  gh.lazySingleton<_i9.INoteRepository>(
      () => _i10.NoteRepository(get<_i5.FirebaseFirestore>()));
  gh.factory<_i11.NoteActorBloc>(
      () => _i11.NoteActorBloc(get<_i9.INoteRepository>()));
  gh.factory<_i12.NoteFormBloc>(
      () => _i12.NoteFormBloc(get<_i9.INoteRepository>()));
  gh.factory<_i13.NoteWatcherBloc>(
      () => _i13.NoteWatcherBloc(get<_i9.INoteRepository>()));
  gh.factory<_i14.SignInFormBloc>(
      () => _i14.SignInFormBloc(get<_i7.IAuthFacade>()));
  gh.factory<_i15.AuthBloc>(() => _i15.AuthBloc(get<_i7.IAuthFacade>()));
  return get;
}

class _$AppRouterInjectableModule extends _i16.AppRouterInjectableModule {}

class _$FirebaseInjectableModule extends _i17.FirebaseInjectableModule {}
