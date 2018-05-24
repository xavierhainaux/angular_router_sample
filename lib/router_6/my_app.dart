import 'dart:async';

import 'package:angular/angular.dart';
import 'router.dart';

import 'my_app.template.dart' as self;

@Component(selector: 'body', template: '''
<h1>My app</h1>
<router base="/extranet">
  <ul>
    <li><a link="dashboard">Dashboard</a></li>
    <li><a link="games">Games</a></li>
  </ul>
  <button (click)="doSomething()">Do something</button>

  <router-outlet [routes]="routes"></router-outlet>
</router>
''', directives: const [routerDirectives])
class MyAppComponent {
  doSomething() {

  }

  final List<RouteDefinition> routes = [
    new RouteDefinition('dashboard', self.MyDashboardPageNgFactory),
    new RouteDefinition('games', self.MyGamePageNgFactory),
  ];
}

@Component(selector: 'my-dashboard-page', template: '''
<h1>Dashboard</h1>
''')
class MyDashboardPage implements Page {
  @override
  onActivate(Route route) {
    // TODO: implement onActivate
  }
}

@Component(selector: 'my-games-page', template: '''
  <h2>Games</h2>
  <ul>
    <li><a link="">List</a></li>
  </ul>

  <router-outlet [routes]="routes"></router-outlet>
''', directives: const [
  routerDirectives,
])
class MyGamePage extends Page {
  @override
  onActivate(Route route) {
    // TODO: implement onActivate
  }

  final List<RouteDefinition> routes = [
    new RouteDefinition('list', self.GameListPageNgFactory),
    new RouteDefinition('detail/(id)', self.GameDetailPageNgFactory),
  ];

}

@Component(selector: 'my-game-list', template: '''
<table></table>
''')
class GameListPage extends Page {
  @override
  onActivate(Route route) {
    // Fetch la liste des jeux
  }
}

@Component(selector: 'my-game-detail', template: '''
<template [ngIf]="game != null">
  <a link="../">List</a>  
  <h3>My game {{game}}</h3>
  <ul>
    <li><a link="description">Description</a></li>
    <li><a link="related">Related</a></li>
  </ul>

  <!--<description-page *page="description"></description-page>
  <related-page *page="related"></related-page>-->

</template>
''', directives: const [
  coreDirectives,
  routerDirectives
])
class GameDetailPage implements Page {
  Map<String, String> game;

  @override
  onActivate(Route route) async {
    String gameId = route.parameters['gameId'];

    // Pouvoir aussi écrire:
    // tous les paramètres de toutes les routes mergé
    // current.allParameters['gameId'];
    // Juste les paramètres pour la route en cours:
//    route.parameters['gameId'];
//
//    // Lister les autres Paths
//    route.ancestors.first.parameters['x'];

    await new Future.delayed(const Duration(seconds: 1));
    game = {'id': gameId}; // downloadGame(gameId);
  }
}
/*
@Component(selector: 'game-description', template: '''
<a [link]="../../list">Games</a>
<a link="../../../categories/{{categoryId}}">My category</a>
<h4>{{game.name}}</h4>

<button (click)="save()">Save</button>
''')
class GameDetailDescriptionPage implements Page {
  final GameDetailPage _parent;
  final Router _router;

  GameDetailDescriptionPage(this._parent, this._router);

  @override
  onActivate(Route previous, Route current) {
    // Fetch la description complète du jeu et peut accéder à _parent.
  }

  save() {
    _router.navigateTo('../list');
    _router.navigateTo('/games/list');
  }
}

*/
