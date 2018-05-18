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
<router-outlet [routes]="routes" *ngIf="isInitialized"></router-outlet>
''',
  directives: const [coreDirectives, routerDirectives],
)
class BodyComponent implements OnInit {
  bool isInitialized = false;

  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: rootRoute, component: self.AppComponentNgFactory),
  ];

  @override
  void ngOnInit() async {
    isInitialized = true;
  }
}

@Component(
  selector: 'my-app',
  template: '''
<message-manager>
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
</message-manager>
''',
  directives: const [routerDirectives, MessageManagerComponent],
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


@Component(selector: 'message-manager', template: '''
Message manager wrapper
<ng-content></ng-content>
''')
class MessageManagerComponent {

}