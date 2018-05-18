import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'main.template.dart' as self;

@GenerateInjector(const [
  routerProvidersHash,
])
final InjectorFactory injector = self.injector$Injector;

main() {
  runApp(
    self.BodyComponentNgFactory,
    createInjector: injector,
  );
}

@Component(
    selector: 'body',
    template: '<router-outlet [routes]="routes"></router-outlet>',
    directives: const [RouterOutlet])
class BodyComponent {
  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: new RoutePath(path: ''),
        component: self.AppComponentNgFactory),
  ];
}

@Component(selector: 'my-app', template: '''
<button (click)="isInitialized = true">Initialize</button>
<div *ngIf="isInitialized">
  <h2>App initialized</h2>
  <router-outlet [routes]="routes"></router-outlet>
</div>
''', directives: [routerDirectives, coreDirectives])
class AppComponent {
  // If `isInitialized is initially `true`, then the router-outlet works!
  bool isInitialized = false;

  List<RouteDefinition> get routes => [
    new RouteDefinition(
        routePath: new RoutePath(path: '', useAsDefault: true),
        component: self.FirstPageComponentNgFactory),
  ];
}

@Component(selector: 'first-page', template: 'FirstPage')
class FirstPageComponent {}
