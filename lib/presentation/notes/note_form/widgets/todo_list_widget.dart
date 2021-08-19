import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:kt_dart/kt.dart';
import 'package:resolly/application/notes/note_form/note_form_bloc.dart';
import 'package:resolly/domain/notes/value_objects.dart';
import 'package:resolly/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:resolly/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Want longer? Activate premium 😍'),
            action: SnackBarAction(
              label: 'BUY NOW',
              onPressed: () {},
            ),
          ));
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              removeDuration: const Duration(),
              onReorderFinished: (item, from, to, newItems) {
                context.formTodos = newItems.toImmutableList();
                context
                    .read<NoteFormBloc>()
                    .add(NoteFormEvent.todosChanged(context.formTodos));
              },
              shrinkWrap: true,
              // removeDuration: const Duration(microseconds: 50),
              items: formTodos.value.asList(),
              itemBuilder: (context, itemAnimation, item, index) => Reorderable(
                    key: Key(item.id.getOrCrash()),
                    builder: (context, animation, inDrag) => ScaleTransition(
                      scale:
                          Tween<double>(begin: 1, end: 0.95).animate(animation),
                      child: TodoTile(
                        index: index,
                        elevation: animation.value * 4,
                      ),
                    ),
                  ));
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  const TodoTile({
    required this.index,
    double? elevation,
    Key? key,
  })  : elevation = elevation ?? 0,
        super(key: key);

  final int index;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final textEditingController = useTextEditingController(text: todo.name);
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.formTodos = context.formTodos.minusElement(todo);
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          animationDuration: const Duration(microseconds: 50),
          elevation: elevation,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              trailing: const Handle(child: Icon(Icons.list)),
              leading: Checkbox(
                onChanged: (value) {
                  if (value != null) {
                    context.formTodos = context.formTodos.map(
                      (listTodo) => listTodo == todo
                          ? todo.copyWith(done: value)
                          : listTodo,
                    );
                    context
                        .read<NoteFormBloc>()
                        .add(NoteFormEvent.todosChanged(context.formTodos));
                  }
                },
                value: todo.done,
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Todo',
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: TodoName.maxLenght,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(name: value)
                        : listTodo,
                  );
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) {
                  return context
                      .read<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                        (f) => null,
                        (todoList) => todoList[index].name.value.fold(
                            (f) => f.maybeMap(
                                  exceedingLenght: (_) => 'exceedingLenght',
                                  empty: (_) => 'empty',
                                  multiline: (_) => 'multiline',
                                  orElse: () => 'orElse',
                                ),
                            (_) => null),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
