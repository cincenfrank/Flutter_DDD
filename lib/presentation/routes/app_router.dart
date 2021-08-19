import 'package:auto_route/annotations.dart';
import 'package:resolly/presentation/notes/note_form/note_form_page.dart';
import 'package:resolly/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:resolly/presentation/sign_in/sign_in_page.dart';
import 'package:resolly/presentation/splash/splash_page.dart';

@MaterialAutoRouter(routes: [
  MaterialRoute(page: SplashPage, initial: true),
  MaterialRoute(page: SignInPage),
  MaterialRoute(page: NotesOverviewPage),
  MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
])
class $AppRouter {}
