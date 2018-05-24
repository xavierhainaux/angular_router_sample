import 'dart:async';

import 'package:angular/angular.dart';
import 'router_public.dart';

import 'my_app.template.dart' as self;

@Component(selector: 'body', template: '''
<h1>My app</h1>
<router base="extranet">
  <ul>
    <li><a link="dashboard">Dashboard</a></li>
    <li><a link="games">Games</a></li>
  </ul>
  <button (click)="doSomething()">Do something</button>

  <router-outlet [routes]="routes"></router-outlet>
</router>
''', directives: const [routerDirectives])
class MyAppComponent {
  doSomething() {}

  final List<RouteDefinition> routes = [
    new RouteDefinition('dashboard', self.MyDashboardPageNgFactory),
    new RouteDefinition('games', self.MyGamePageNgFactory),
  ];
}

@Component(selector: 'my-dashboard-page', template: '''
<h1>Dashboard</h1>
''')
class MyDashboardPage implements OnInit {
  final Route _route;

  MyDashboardPage(this._route);

  @override
  ngOnInit() {}
}

@Component(selector: 'my-games-page', template: '''
  <h2>Games</h2>
  <ul>
    <li><a link="list">List</a></li>
    <li><a link="detail/12">Detail 12</a></li>
  </ul>

  <router-outlet [routes]="routes"></router-outlet>
''', directives: const [
  routerDirectives,
])
class MyGamePage {
  final List<RouteDefinition> routes = [
    new RouteDefinition('list', self.GameListPageNgFactory),
    new RouteDefinition('detail/:id', self.GameDetailPageNgFactory),
  ];
}

@Component(selector: 'my-game-list', template: '''
This is the list
<table></table>
''')
class GameListPage {}

@Component(
    selector: 'my-game-detail',
    template: '''
<template [ngIf]="game != null">
  <a link="../">List</a>  
  <h3>My game {{game.name}}</h3>
  <ul>
    <li><a link="description">Description</a></li>
    <li><a link="related">Related</a></li>
  </ul>

  <router-outlet [routes]="routes"></router-outlet>
</template>
''',
    directives: const [coreDirectives, routerDirectives],
    visibility: Visibility.all)
class GameDetailPage implements OnInit {
  final Route _route;
  Game game;

  GameDetailPage(this._route);

  final List<RouteDefinition> routes = [
    new RouteDefinition('description', self.GameDetailDescriptionPageNgFactory),
    new RouteDefinition('related', self.RelatedPageNgFactory),
  ];

  @override
  ngOnInit() async {
    String gameId = _route.parameters['id'];

    // Pouvoir aussi écrire:
    // tous les paramètres de toutes les routes mergé
    // current.allParameters['gameId'];
    // Juste les paramètres pour la route en cours:
//    route.parameters['gameId'];
//
//    // Lister les autres Paths
//    route.ancestors.first.parameters['x'];

    await new Future.delayed(const Duration(seconds: 1));
    game = new Game(gameId); // downloadGame(gameId);
  }
}

@Component(selector: 'game-description', template: '''
<a link="../../../list">Games</a>
<a link="../../../categories/{{categoryId}}">My category</a>
<h4>{{game.name}}</h4>

<button (click)="save()">Save</button>
''', directives: const [routerDirectives])
class GameDetailDescriptionPage {
  final GameDetailPage _parent;
  final Router _router;

  GameDetailDescriptionPage(this._parent, this._router);

  String get categoryId => 'MyCategory';

  Game get game => _parent.game;

  save() {
    //TODO(xha): il faut un Router mais qui soit configuré pour le RouterOutlet
    // parent.
    //_router.navigateTo('../../../list');
  }
}

@Component(selector: 'related', template: '''
<h5>Related</h5>
''')
class RelatedPage {}

class Game {
  final String id;
  String get name => 'Game($id)';

  Game(this.id);
}
