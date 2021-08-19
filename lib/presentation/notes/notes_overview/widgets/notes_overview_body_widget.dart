import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:resolly/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:resolly/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:resolly/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
        builder: (context, state) {
      return state.map(
        initial: (_) => Container(),
        loadInProgress: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        loadSuccess: (s) {
          return ListView.builder(
            itemCount: s.notes.size,
            itemBuilder: (context, index) {
              final note = s.notes[index];
              return note.failureOption.fold(
                () => NoteCard(note: note),
                (valueFailure) => ErrorNoteCard(note: note),
              );
            },
          );
        },
        loadFailure: (s) => CriticalFailureDisplay(
          failure: s.noteFailure,
        ),
      );
    });
  }
}
