import 'package:flutter/material.dart';
import 'package:resolly/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:resolly/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:resolly/presentation/notes/note_form/misc/build_context_x.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  void _showGoPremiumSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Want longer? Activate premium 😍'),
      action: SnackBarAction(
        label: 'BUY NOW',
        onPressed: () {},
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<NoteFormBloc, NoteFormState>(
            listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
            listener: (context, state) {
              if (state.note.todos.isFull) {
                _showGoPremiumSnackBar(context);
              }
            },
          ),
          BlocListener<NoteFormBloc, NoteFormState>(
            listenWhen: (p, c) => p.isEditing != c.isEditing,
            listener: (context, state) {
              context.formTodos = state.note.todos.value.fold(
                (f) => listOf<TodoItemPrimitive>(),
                (todoItemList) =>
                    todoItemList.map((_) => TodoItemPrimitive.fromDomain(_)),
              );
            },
          ),
        ],
        child: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
          builder: (context, state) {
            return ListTile(
              title: const Text('Add a Todo'),
              leading: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.add),
              ),
              onTap: () {
                if (state.note.todos.isFull) {
                  _showGoPremiumSnackBar(context);
                } else {
                  context.formTodos =
                      context.formTodos.plusElement(TodoItemPrimitive.empty());
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                }
              },
            );
          },
        ));
  }
}
