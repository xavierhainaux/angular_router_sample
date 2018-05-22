import 'package:angular/angular.dart';
import 'package:my_angular_project/router_3/my_app.template.dart' as app;
import 'package:my_angular_project/router.dart';

import 'main.template.dart' as self;

@GenerateInjector(const [
  routerProviders
])
final InjectorFactory injector = self.injector$Injector;

main() {
  runApp(
    app.MyAppComponentNgFactory,
    createInjector: injector,
  );
}
