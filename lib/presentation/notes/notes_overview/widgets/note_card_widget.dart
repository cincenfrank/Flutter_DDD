import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resolly/application/notes/note_actor/note_actor_bloc.dart';
import 'package:resolly/domain/notes/note.dart';
import 'package:kt_dart/kt.dart';
import 'package:resolly/domain/notes/todo_item.dart';
import 'package:provider/provider.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(NoteFormPageRoute(
            editingNote: note,
          ));
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 8,
                  children: note.todos
                      .getOrCrash()
                      .map((todo) => TodoDisplay(todoItem: todo))
                      .asList(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selected note'),
            content: Text(
              note.body.getOrCrash(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  noteActorBloc.add(NoteActorEvent.deleted(note));
                  Navigator.pop(context);
                },
                child: const Text('DELETE'),
              )
            ],
          );
        });
  }
}

class TodoDisplay extends StatelessWidget {
  const TodoDisplay({
    Key? key,
    required this.todoItem,
  }) : super(key: key);

  final TodoItem todoItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todoItem.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).accentColor,
          ),
        if (!todoItem.done)
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          ),
        Text(todoItem.name.getOrCrash()),
      ],
    );
  }
}
