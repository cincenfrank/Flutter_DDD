import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:resolly/application/notes/note_form/note_form_bloc.dart';

import 'package:resolly/domain/notes/note.dart';
import 'package:resolly/injection.dart';
import 'package:resolly/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:resolly/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:resolly/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:resolly/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:resolly/presentation/notes/note_form/widgets/todo_list_widget.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class NoteFormPage extends StatelessWidget {
  const NoteFormPage({
    Key? key,
    required this.editingNote,
  }) : super(key: key);

  final Note? editingNote;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(optionOf(editingNote)),
        ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(() => {}, (either) {
            either.fold((failure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(failure.map(
                      unexpected: (_) => 'unexpected',
                      insufficientPermission: (_) => 'insufficientPermission',
                      unableToUpdate: (_) => 'unableToUpdate'))));
            }, (r) {
              AutoRouter.of(context).popUntil((route) =>
                  route.settings.name == NotesOverviewPageRoute.name);
            });
          });
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) => Stack(
          children: [
            const NoteFormPageScaffold(),
            SavingInProgressOverlay(
              isSaving: state.isSaving,
            ),
          ],
        ),
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);
  final bool isSaving;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Saving',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(
              state.isEditing ? 'Edit a Note' : 'Create a note',
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
                autovalidateMode: state.showErrorMessages
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const BodyField(),
                      const ColorField(),
                      const TodoList(),
                      const AddTodoTile(),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
