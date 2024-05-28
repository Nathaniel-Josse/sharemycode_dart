import 'package:auto_route/auto_route.dart';

import '../controllers/content.controller.dart';
import '../controllers/logs.controller.dart';
import '../controllers/user.controller.dart';
import '../pages/home.page.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomePage,
          children: [
            AutoRoute(path: 'users', page: UserController),
            AutoRoute(path: 'content', page: ContentController),
            AutoRoute(path: 'log', page: LogsController),
          ],
        ),
      ];
}
