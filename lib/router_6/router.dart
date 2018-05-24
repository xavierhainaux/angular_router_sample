import 'package:angular/angular.dart';

const List<Provider> routerProviders = const [];

const List<Type> routerDirectives = const [
  Router,
  LinkDirective,
  RouterOutlet,
];

class RouteDefinition {
  final String url;
  final ComponentFactory componentFactory;

  RouteDefinition(this.url, this.componentFactory);
}

@Component(
    selector: 'router',
    template: '<ng-content></ng-content>',
    visibility: Visibility.all)
class Router {
  Router();

  String base;

  void navigateTo(String url) {}
}

class Route {
  List<Route> ancestors;

  Map<String, String> parameters = {};

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
  Map<String, String> get allParameters => {};
}

class Page {
  onActivate(Route route) {}
}

@Component(
    selector: 'router-outlet',
    template: '''

''',
    visibility: Visibility.all,
    providers: const [
      const Provider(RouterOutletToken),
    ])
class RouterOutlet {
  final ViewContainerRef _viewContainerRef;
  final RouterOutletToken _parent;

  RouterOutlet(this._viewContainerRef, @Self() RouterOutletToken self,
      @SkipSelf() @Optional() this._parent) {
    self.routerOutlet = this;
    print('router-outlet: ${_parent?.routerOutlet}');
  }

  List<RouteDefinition> _routes;
  @Input()
  set routes(List<RouteDefinition> routes) {
    _routes = routes;

    RouteDefinition def = routes.last;
    final componentRef = def.componentFactory
        .create(new Injector.map({}, _viewContainerRef.injector));
    componentRef.changeDetectorRef.detectChanges();

    _viewContainerRef.insert(componentRef.hostView);

    var instance = componentRef.instance;
    if (instance is Page) {
      instance.onActivate(new Route());
    }
  }
}

class RouterOutletToken {
  RouterOutlet routerOutlet;
}

@Directive(selector: '[link]')
class LinkDirective {
  @Input()
  set link(String link) {}
}
