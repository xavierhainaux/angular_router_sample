import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:my_angular_project/routes.dart';

import 'app_component.template.dart' as self;
import 'src/dashboard.template.dart' as dashboard;
import 'src/build.template.dart' as build;

@Component(
  selector: 'body',
  template: '''
<h1>THE BODY </h1>
<router-outlet [routes]="routes"></router-outlet>
''',
  directives: const [RouterOutlet],
)
class BodyComponent {
  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: rootRoute, component: self.AppComponentNgFactory),
  ];
}

@Component(
  selector: 'my-app',
  template: '''
<h2>The app</h2>  

<ul>
  <li><a [routerLink]="dashboardUrl" routerLinkActive="active-route">Dashboard</a></li>
  <li><a [routerLink]="buildsUrl" routerLinkActive="active-route">Builds</a></li>
</ul>

<router-outlet [routes]="routes"></router-outlet>
<style>
.active-route {
  color: red;
}
</style>
''',
  directives: const [RouterOutlet, RouterLink, RouterLinkActive],
)
class AppComponent {
  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: dashboardRoute,
        component: dashboard.DashboardComponentNgFactory),
    new RouteDefinition(
        routePath: buildsRoute,
        component: build.MasterDetailBuildsComponentNgFactory),
  ];

  String get dashboardUrl => dashboardRoute.toUrl();
  String get buildsUrl => buildsRoute.toUrl();
}
