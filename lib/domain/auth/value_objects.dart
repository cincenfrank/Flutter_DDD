import 'package:dartz/dartz.dart';
import 'package:resolly/domain/core/failures.dart';
import 'package:resolly/domain/core/value_objects.dart';
import 'package:resolly/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  // Factory constructor created in order to add validation logic
  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Password extends ValueObject<String> {
  // Factory constructor created in order to add validation logic
  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }
  const Password._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
