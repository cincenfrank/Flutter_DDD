import 'package:injectable/injectable.dart';
import 'package:resolly/presentation/routes/app_router.gr.dart';

@module
abstract class AppRouterInjectableModule {
  @lazySingleton
  AppRouter get appRouter => AppRouter();
}
