import 'package:angular_router/angular_router.dart';

final RoutePath rootRoute = new RoutePath(path: '');
final RoutePath dashboardRoute = new RoutePath(path: '', parent: rootRoute);
final RoutePath buildsRoute = new RoutePath(path: 'builds', parent: rootRoute);
