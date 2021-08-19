import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resolly/application/notes/note_form/note_form_bloc.dart';
import 'package:resolly/domain/notes/value_objects.dart';
import 'package:resolly/injection.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'Note',
            counterText: '',
          ),
          maxLength: NoteBody.maxLenght,
          maxLines: null,
          minLines: 5,
          onChanged: (value) {
            context.read<NoteFormBloc>().add(NoteFormEvent.bodyChanged(value));
          },
          validator: (_) => getIt<NoteFormBloc>().state.note.body.value.fold(
              (f) => f.maybeMap(
                    empty: (f) => 'Cannot be Empty',
                    exceedingLenght: (f) => 'Exceeding lenght, max ${f.max}',
                    orElse: () => 'null',
                  ),
              (_) => null),
        ),
      ),
    );
  }
}
