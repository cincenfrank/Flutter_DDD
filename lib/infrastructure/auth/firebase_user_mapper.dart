import 'package:firebase_auth/firebase_auth.dart';
import 'package:resolly/domain/auth/app_user.dart';
import 'package:resolly/domain/core/value_objects.dart';

extension FirebaseUserDomainX on User {
  AppUser toDomain() {
    return AppUser(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
