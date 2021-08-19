import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:resolly/domain/notes/i_note_repository.dart';
import 'package:resolly/domain/notes/note.dart';
import 'package:resolly/domain/notes/note_failure.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  NoteWatcherBloc(this._noteRepository) : super(const _Initial());

  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  @override
  Stream<NoteWatcherState> mapEventToState(
    NoteWatcherEvent event,
  ) async* {
    yield* event.map(
      watchAllStarted: (a) async* {
        yield const NoteWatcherState.loadInProgress();
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription =
            _noteRepository.watchAll().listen((failureOrNote) {
          add(NoteWatcherEvent.notesReceived(failureOrNote));
        });
      },
      notesReceived: (a) async* {
        yield a.failureOrNote.fold(
            (noteFailure) => NoteWatcherState.loadFailure(noteFailure),
            (notes) => NoteWatcherState.loadSuccess(notes));
      },
      watchUncompletedStarted: (a) async* {
        yield const NoteWatcherState.loadInProgress();
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription =
            _noteRepository.watchUncompleted().listen((failureOrNote) {
          add(NoteWatcherEvent.notesReceived(failureOrNote));
        });
      },
    );
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
