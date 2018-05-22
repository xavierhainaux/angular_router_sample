import 'package:angular/angular.dart';

const List<Provider> routerProviders = const [];

const List<Type> routerDirectives = const [
  Router,
  PageDirective,
  LinkDirective,
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

  _registerDirective(PageDirectiveHolder holder) {
    //TODO(xha): lancer une exception si il y a un conflit sur les routes en cours.

    // Poster une nouvelle tâche pour mettre à jour les composants
  }

  _unregisterDirective(PageDirectiveHolder holder) {}

  _updateDirectives() {
    // TODO(xha):
  }

  @ContentChildren(PageDirective, descendants: true)
  set pages(List pages) {
    print('Set pages: $pages');
  }
}

class Route {
  List<Route> ancestors;

  Map<String, String> parameters;

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
  Map<String, String> get allParameters => {};
}

class Page {
  onActivate(Route route) {}

}

@Directive(
    selector: '[page]', providers: const [const Provider(PageDirectiveHolder)])
class PageDirective implements OnInit, OnDestroy {
  final PageDirectiveHolder _selfHolder;
  final Router _router;
  final TemplateRef _templateRef;
  final ViewContainerRef _viewContainer;
  final List _pageComponent;

  PageDirective(
      this._router,
      this._viewContainer,
      this._templateRef,
      @Optional() @SkipSelf() PageDirectiveHolder parentHolder,
      @Self() this._selfHolder,
     @Self() @Optional() @Inject(Page) this._pageComponent) {
    _selfHolder.directive = this;
    _selfHolder.parent = parentHolder;
    print('pp $_pageComponent');
  }

  String get page => _page;
  String _page;
  @Input()
  set page(String url) {
    //assert(_page == null, '[page] can be set only once');

    _page = url;
    print('[page]=$url');

    if (true) {
      _viewContainer.createEmbeddedView(_templateRef);
    } else {
      _viewContainer.clear();
    }
  }

  @override
  void ngOnInit() {
    assert(_page != null, '[page] should have been set');

    _router._registerDirective(_selfHolder);
  }

  @override
  void ngOnDestroy() {
    _router._unregisterDirective(_selfHolder);
  }
}

class PageDirectiveHolder {
  PageDirectiveHolder parent;
  PageDirective directive;
  String get name => directive.page;

  Iterable<PageDirectiveHolder> get ancestorsAndSelf sync* {
    if (parent != null) {
      yield* parent.ancestorsAndSelf;
    }
    yield this;
  }

  String get fullUrlPattern => ancestorsAndSelf.map((d) => d.name).join('/');

  toString() => 'ParentProvider($fullUrlPattern)';
}

@Directive(selector: '[link]')
class LinkDirective {

  @Input()
  set link(String link) {

  }
}
