import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolly/application/auth/bloc/auth_bloc.dart';
import 'package:resolly/application/notes/note_actor/note_actor_bloc.dart';
import 'package:resolly/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:resolly/injection.dart';
import 'package:resolly/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:resolly/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) => state.maybeMap(
                orElse: () {},
                unauthenticated: (_) => AutoRouter.of(context).replace(
                      const SignInPageRoute(),
                    )),
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
              listener: (context, state) => state.maybeMap(
                    orElse: () {},
                    deleteFailure: (s) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        s.noteFailure.map(
                            unexpected: (_) => 'unexpected',
                            insufficientPermission: (_) =>
                                'insufficientPermission ❌',
                            unableToUpdate: (_) =>
                                'unableToUpdate - Impossible Error'),
                      )));
                    },
                  ))
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signedOut());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
            actions: [
              UncompletedSwitch(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(NoteFormPageRoute(editingNote: null));
            },
            child: const Icon(Icons.add),
          ),
          body: const NotesOverviewBody(),
        ),
      ),
    );
  }
}
