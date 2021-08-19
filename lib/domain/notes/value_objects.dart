import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:resolly/domain/core/failures.dart';
import 'package:resolly/domain/core/value_objects.dart';
import 'package:resolly/domain/core/value_transformers.dart';
import 'package:resolly/domain/core/value_validators.dart';

class NoteBody extends ValueObject<String> {
  // Factory constructor created in order to add validation logic
  factory NoteBody(String input) {
    return NoteBody._(
      // Se il primocontrollo rilascia errore il flat map viene skippato
      validateMaxStringLenght(input, maxLenght).flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLenght = 1000;
}

class TodoName extends ValueObject<String> {
  // Factory constructor created in order to add validation logic
  factory TodoName(String input) {
    return TodoName._(
      // Se il primocontrollo rilascia errore il flat map viene skippato
      validateMaxStringLenght(input, maxLenght)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateSingleLine),
    );
  }

  const TodoName._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLenght = 30;
}

class NoteColor extends ValueObject<Color> {
  // Factory constructor created in order to add validation logic
  factory NoteColor(Color input) {
    return NoteColor._(
      right(makeColorOpaque(input)),
    );
  }

  const NoteColor._(this.value);

  @override
  final Either<ValueFailure<Color>, Color> value;

  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];
}

class List3<T> extends ValueObject<KtList<T>> {
  // Factory constructor created in order to add validation logic
  factory List3(KtList<T> input) {
    return List3<T>._(validateMaxListLenght(
      input,
      maxLenght,
    ));
  }

  const List3._(this.value);

  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const maxLenght = 3;

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    return length == maxLenght;
  }
}
