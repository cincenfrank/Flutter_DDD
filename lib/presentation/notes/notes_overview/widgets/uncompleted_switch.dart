import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/notes/note_watcher/note_watcher_bloc.dart';

class UncompletedSwitch extends HookWidget {
  //UncompletedSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final togglestate = useState(false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkResponse(
        onTap: () {
          togglestate.value = !togglestate.value;
          context.read<NoteWatcherBloc>().add(
                togglestate.value
                    ? const NoteWatcherEvent.watchUncompletedStarted()
                    : const NoteWatcherEvent.watchAllStarted(),
              );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: togglestate.value
              ? const Icon(
                  Icons.check_box_outline_blank,
                  key: Key('check_box_outline_blank'),
                )
              : const Icon(
                  Icons.indeterminate_check_box,
                  key: Key('indeterminate_check_box'),
                ),
        ),
      ),
    );
  }
}
