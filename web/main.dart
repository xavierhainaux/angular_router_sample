import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:my_angular_project/app_component.template.dart' as app;

import 'main.template.dart' as self;

@GenerateInjector(const [
  const ValueProvider.forToken(appBaseHref, '/extranet'),
  routerProviders,
])
final InjectorFactory injector = self.injector$Injector;

main() {
  runApp(
    app.BodyComponentNgFactory,
    createInjector: injector,
  );
}