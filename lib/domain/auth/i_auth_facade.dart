import 'package:dartz/dartz.dart';
import 'package:resolly/domain/auth/auth_failure.dart';
import 'package:resolly/domain/auth/app_user.dart';
import 'package:resolly/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Option<AppUser>> getSignedInUser();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}
