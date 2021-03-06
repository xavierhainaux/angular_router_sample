import 'package:angular/angular.dart';

const List<Provider> routerProviders = const [];

const List<Type> routerDirectives = const [
  Router,
  LinkDirective,
  Page,
];

@Component(
    selector: 'router',
    template: '<ng-content></ng-content>',
    visibility: Visibility.all)
class Router {
  Router();

  String base;

  void navigateTo(String url) {}

  _updateDirectives() {
    // TODO(xha):
  }
}

class Route {
  final Page page;

  Route(this.page);

  toString() => page.url ?? '<no>';

  /*List<Route> ancestors;

  Map<String, String> parameters;

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
  Map<String, String> get allParameters => {};*/
}

abstract class OnActivate {
  onActivate(Route route);
}

routeFactory(Page page) {
  print('Get route ${page.url}');

  return new Route(page);
}

@Component(selector: 'page', template: '''
<template [ngIf]="true">
  <ng-content></ng-content>
</template>
''', directives: const [
  coreDirectives
], providers: const [
  const Provider(Route, useFactory: routeFactory),
], visibility: Visibility.all)
class Page implements OnInit, OnDestroy, PageInterface {


  @Input()
  String url;

  @override
  void ngOnInit() {
    // S'enregistre sur le Router et
  }

  @override
  void ngOnDestroy() {
    // TODO: implement ngOnDestroy
  }

  @ContentChildren(OnActivate)
  set pages(List<OnActivate> children) {
    print('[page] Set pages ${children}');
  }
}

abstract class PageInterface {
  String get url;
}

/*
@Directive(
    selector: '[page]', providers: const [const Provider(PageDirectiveHolder)])
class PageDirective implements OnInit, OnDestroy {
  final PageDirectiveHolder _selfHolder;
  final Router _router;
  final TemplateRef _templateRef;
  final ViewContainerRef _viewContainer;

  PageDirective(
      this._router,
      this._viewContainer,
      this._templateRef,
      @Optional() @SkipSelf() PageDirectiveHolder parentHolder,
      @Self() this._selfHolder) {
    _selfHolder.directive = this;
    _selfHolder.parent = parentHolder;
    assert(_selfHolder != null);
  }

  String get page => _page;
  String _page;
  @Input()
  set page(String url) {
    assert(_page == null);

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
    assert(_page != null);

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
}*/

@Directive(selector: '[link]')
class LinkDirective {
  @Input()
  set link(String link) {}
}
