import 'dart:async';

import 'package:angular/angular.dart';
import 'package:my_angular_project/router_6/location.dart' as location;
import 'dart:html' as html;
import 'package:path/path.dart' as p;

import 'package:my_angular_project/router_6/path.dart';

const List<Type> routerDirectives = const [
  RouterDirective,
  LinkDirective,
  RouterOutlet,
];

class RouteDefinition {
  final String pathPattern;
  final ComponentFactory componentFactory;

  RouteDefinition(this.pathPattern, this.componentFactory);
}

@Injectable()
class Router {
  final RouterDirective _router;
  final RouterOutlet _parent;

  Router(this._router, @Optional() this._parent);

  void navigateTo(String url) {
    _router._navigateTo(_router._getFullUrl(url, _parent));
  }

  String getFullUrl(String url) => _router._getFullUrl(url, _parent);

  String get url => _router._location.url;

  Stream<String> get onUrlChange => _router.onUrlChange;
}

@Component(
    selector: 'router',
    template: '<ng-content></ng-content>',
    visibility: Visibility.all,
    providers: const [
      const Provider(Router),
    ])
class RouterDirective implements OnInit, OnDestroy {
  final location.Location _location = new location.Location();
  final StreamController<String> _onChangeController =
      new StreamController<String>.broadcast();
  StreamSubscription _popStateSubscription;

  @Input()
  set base(String base) {
    _location.base = base;
  }

  Stream<String> get onUrlChange => _onChangeController.stream;

  void _navigateTo(String url) {
    _location.url = url;
    _onChangeController.add(_location.url);
  }

  void registerPath(RouterOutlet outlet, Iterable<String> pathPatterns) {
    _location.register(outlet, pathPatterns);
  }

  void unRegisterOutlet(RouterOutlet outlet) {
    _location.unRegister(outlet);
  }

  _onPopState(html.PopStateEvent e) {
    _navigateTo(html.window.location.pathname);
  }

  @override
  void ngOnInit() {
    _popStateSubscription = html.window.onPopState.listen((_onPopState));
    _navigateTo(html.window.location.pathname);
  }

  @override
  void ngOnDestroy() {
    _popStateSubscription.cancel();
  }

  String _getFullUrl(String link, RouterOutlet parent) {
    return _location.getFullUrl(link, parent);
  }
}

@Directive(
    selector: 'router-outlet',
    providers: const [
      const Provider(RouterOutletToken),
      const Provider(Router),
    ],
    visibility: Visibility.all)
class RouterOutlet implements location.RouterOutlet, OnDestroy {
  final RouterDirective _router;
  final ViewContainerRef _viewContainerRef;
  final RouterOutletToken _parent;
  ComponentRef _currentComponent;
  Peek _currentPeek;

  RouterOutlet(this._router, this._viewContainerRef,
      @Self() RouterOutletToken self, @SkipSelf() @Optional() this._parent) {
    self.routerOutlet = this;
  }

  List<RouteDefinition> _routes;
  @Input()
  set routes(List<RouteDefinition> routes) {
    assert(_routes == null || _routes == routes, "Routes can't change");

    if (_routes != routes) {
      _routes = routes;
      _router.registerPath(this, _routes.map((d) => d.pathPattern));
    }
  }

  String get currentPath => _currentPeek.joinedSegments;

  @override
  activate(Peek peek, location.Route route) {
    // On ne peut pas activer directement le composant pour ne pas avoir une boucle
    // infinie dans le set url.
    // TODO(xha): c'est un hack, il faudrait trouver la façon propre de angular
    // pour gérer des cas comme ça.
    Timer.run(() {
      _removeCurrent();

      _currentPeek = peek;
      RouteDefinition routeDefinition =
          _routes.firstWhere((r) => r.pathPattern == peek.pattern.original);

      final componentRef = routeDefinition.componentFactory.create(
          new Injector.map(
              {location.Route: route}, _viewContainerRef.injector));
      componentRef.changeDetectorRef.detectChanges();

      _viewContainerRef.insert(componentRef.hostView);

      _currentComponent = componentRef;
    });
  }

  @override
  deactivate(String pathPattern) {
    assert(_currentPeek.pattern.original == pathPattern,
        'desactivate ${_currentPeek.pattern} vs $pathPattern');

    _removeCurrent();
  }

  _removeCurrent() {
    if (_currentComponent != null) {
      _currentComponent.destroy();
      _viewContainerRef.clear();

      _currentComponent = null;
    }
  }

  @override
  location.RouterOutlet get parent => _parent?.routerOutlet;

  @override
  void ngOnDestroy() {
    _router.unRegisterOutlet(this);
  }
}

class RouterOutletToken {
  RouterOutlet routerOutlet;
}

@Directive(selector: '[link]')
class LinkDirective implements AfterViewInit, OnDestroy {
  final Router _router;
  final html.Element _element;
  String _target;
  StreamSubscription _keyPressSubscription, _onUrlChangeSubscription;

  LinkDirective(
      this._router, @Attribute('target') this._target, this._element) {
    // The browser will synthesize a click event for anchor elements when they
    // receive an Enter key press. For other elements, we must manually add a
    // key press listener to ensure the link remains keyboard accessible.
    if (_element is! html.AnchorElement) {
      _keyPressSubscription = _element.onKeyPress.listen(_onKeyPress);
    }
  }

  @override
  void ngAfterViewInit() {
    _onUrlChangeSubscription = _router.onUrlChange.listen(_onUrlUpdate);
    _onUrlUpdate(_router.url);
  }

  @override
  void ngOnDestroy() {
    _keyPressSubscription?.cancel();
    _onUrlChangeSubscription?.cancel();
  }

  void _onUrlUpdate(String url) {
    bool isActive = _fullPath == url;
    if (!isActive && _link != '') {
      isActive = p.isWithin(_fullPath, url);
    }
    _element.classes.toggle('link-active', isActive);
  }

  String _fullPath, _link;
  @Input()
  set link(String link) {
    _link = link;
    _fullPath = _router.getFullUrl(link);
  }

  /// Indicates the URL when the hovering on the link.
  @HostBinding('attr.href')
  String get visibleHref {
    return _fullPath;
  }

  @HostListener('click')
  void onClick(html.MouseEvent event) {
    // Control-click (or Command-click) opens link in new tab.
    if (event.ctrlKey || event.metaKey) return;
    _trigger(event);
  }

  void _onKeyPress(html.KeyboardEvent event) {
    // Control-click (or Command-click) opens link in new tab.
    if (event.keyCode != html.KeyCode.ENTER || event.ctrlKey || event.metaKey) {
      return;
    }
    _trigger(event);
  }

  void _trigger(html.Event event) {
    if (_link != null) {
      // The presence of target="_blank" opens link in new tab.
      if (_target == null || _target == '_self') {
        event.preventDefault();

        html.window.history.pushState(null, '', _fullPath);
        _router.navigateTo(_link);
      }
    }
  }
}
