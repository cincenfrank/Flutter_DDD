import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:resolly/domain/core/failures.dart';
import 'package:resolly/domain/core/value_objects.dart';
import 'package:resolly/domain/notes/todo_item.dart';
import 'package:resolly/domain/notes/value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  // ignore: sort_unnamed_constructors_first
  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors.first),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(todos
            .getOrCrash()
            // Getting the failureOption from the TodoItem ENTITY - NOT a failureOrUnit from a Value Object
            .map((todoItem) => todoItem.failureOption)
            .filter((o) => o.isSome())
            // if we can't get the 0th element, the list is empty. In such case, it's a valid
            .getOrElse(0, (_) => none())
            .fold(() => right(unit), (f) => left(f)))
        .fold((f) => some(f), (_) => none());
  }
}
