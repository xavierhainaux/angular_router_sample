import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:my_angular_project/routes.dart';
import 'package:my_angular_project/src/routes.dart';

import 'build.template.dart' as self;

@Component(selector: 'master-detail-builds', template: '''
<h3>Builds</h3>

<a [routerLink]="listUrl">List builds</a>
<a [routerLink]="detail1Url">Detail 1</a>
<a [routerLink]="detail2Url">Detail 2</a>

<router-outlet [routes]="routes"></router-outlet>
''', directives: const [RouterOutlet, RouterLink])
class MasterDetailBuildsComponent {
  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: listBuildRoute,
        component: self.ListBuildsComponentNgFactory),
    new RouteDefinition(
        routePath: detailBuildRoute,
        component: self.DetailBuildsComponentNgFactory),
  ];

  String get listUrl => listBuildRoute.toUrl();
  String get detail1Url => detailBuildRoute
      .toUrl(parameters: {'id': '1'}, queryParameters: {'otherParam': 'true'});
  String get detail2Url => detailBuildRoute.toUrl(parameters: {'id': '2'});
}

@Component(selector: 'list-builds', template: '''
<h4>List Builds</h4>
''')
class ListBuildsComponent {}

@Component(selector: 'detail-builds', template: '''
<h4>Detail {{id}}</h4>

<a [routerLink]="noSubDetailUrl">No subDetail</a>
<a [routerLink]="subDetailUrl">SubDetail</a>
<a (click)="navigateSubDetail()">Navigate SubDetail</a>

<router-outlet [routes]="routes"></router-outlet>
''', directives: const [RouterOutlet, RouterLink])
class DetailBuildsComponent implements OnActivate {
  final Router _router;
  String id;

  DetailBuildsComponent(this._router);

  @override
  void onActivate(RouterState previous, RouterState current) {
    id = current.parameters['id'];
  }

  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: noSubDetailRoute,
        component: self.NoSubDetailBuildsComponentNgFactory),
    new RouteDefinition(
        routePath: subDetailRoute,
        component: self.SubDetailBuildsComponentNgFactory),
  ];

  String get noSubDetailUrl =>
      noSubDetailRoute.toUrl(parameters: {'id': id ?? 'no'});
  String get subDetailUrl =>
      subDetailRoute.toUrl(parameters: {'id': id ?? 'no'});

  navigateSubDetail() {
    _router.navigate(subDetailRoute.toUrl(parameters: {'id': id}));
  }
}

final RoutePath noSubDetailRoute =
    new RoutePath(path: '', parent: detailBuildRoute, useAsDefault: true);

@Component(selector: 'no-sub-detail-builds', template: '''
<h4>No Sub Detail {{id}}</h4>
''')
class NoSubDetailBuildsComponent implements OnActivate {
  String id;
  String otherParam;

  @override
  void onActivate(RouterState previous, RouterState current) {
    id = current.parameters['id'];
    otherParam = current.queryParameters['otherParam'];
  }
}

final RoutePath subDetailRoute =
    new RoutePath(path: 'sub-detail', parent: detailBuildRoute);

@Component(selector: 'sub-detail-builds', template: '''
<h4>Sub Detail {{id}}</h4>
''')
class SubDetailBuildsComponent implements OnActivate {
  String id;
  String otherParam;

  @override
  void onActivate(RouterState previous, RouterState current) {
    id = current.parameters['id'];
    otherParam = current.queryParameters['otherParam'];
  }
}
