// uid -> for firestore documents
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resolly/domain/core/value_objects.dart';

part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required UniqueId id,
  }) = _AppUser;
}
