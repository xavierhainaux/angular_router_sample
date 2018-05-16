import 'package:angular_router/angular_router.dart';
import 'package:my_angular_project/routes.dart';

final RoutePath listBuildRoute = new RoutePath(path: '', parent: buildsRoute);
final RoutePath detailBuildRoute =
    new RoutePath(path: 'detail/:id', parent: buildsRoute);
