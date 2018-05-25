import 'package:my_angular_project/router_6/location.dart';
import 'package:my_angular_project/router_6/path.dart';
import 'package:test/test.dart';

main() {
  test('Location life cycle', () {
    // 1. Un outlet enregistre tous les chemins défini et spécifiant son parent (ou le chemin complet?)
    //  => pour chaque enregistrement, on repasse dans la logique comme si l'url changait
    // 2. quand l'url change, on retrouve tous les paths et on regarde ceux qu'on doit instancier.
    // 3. On ne réactive jamais un path déjà instancié.
    // 4. un outlet détruit, dé-enregistre tous ces chemins.

    Location location = new Location()..base = 'extranet';

    List<String> logs = [];
    RouterOutlet rootOutlet = new MockOutlet('root', null, logs);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet, logs);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet, logs);
    RouterOutlet gameAdvancedOutlet =
        new MockOutlet('advanced', gameDetailOutlet, logs);

    location.register(rootOutlet, ['dashboard', 'games']);
    location.register(gamesOutlet, ['list', ':id']);
    location.register(gameDetailOutlet, ['detail']);
    location.register(gameAdvancedOutlet, ['advanced/:type']);

    location.url = 'extranet/games/list';

    expect(
        logs,
        equals([
          'activate(root) games {}',
          'activate(games) list {}',
        ]));
    logs.clear();

    location.url = 'extranet/games';
    expect(logs, equals(['deactivate(games) list']));
    logs.clear();

    location.url = 'extranet/games/12/';
    expect(logs, equals(['activate(games) :id {id: 12}']));
    logs.clear();

    location.url = 'extranet/games/12/detail/advanced/machin';
    expect(
        logs,
        equals([
          'activate(detail) detail {}',
          'activate(advanced) advanced/:type {type: machin}'
        ]));
    logs.clear();
  });

  test('Get full link', () {
    Location location = new Location()..base = 'extranet';

    List<String> logs = [];
    RouterOutlet rootOutlet = new MockOutlet('root', null, logs);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet, logs);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet, logs);
    RouterOutlet gameAdvancedOutlet =
        new MockOutlet('advanced', gameDetailOutlet, logs);

    location.register(rootOutlet, ['dashboard', 'games']);
    location.register(gamesOutlet, ['list', ':id']);
    location.register(gameDetailOutlet, ['detail']);
    location.register(gameAdvancedOutlet, ['advanced/:type']);

    expect(location.getFullUrl('/dashboard', gamesOutlet),
        equals('/extranet/dashboard'));
  });

  test('Location with default', () {
    Location location = new Location()..base = 'extranet';

    List<String> logs = [];
    RouterOutlet rootOutlet = new MockOutlet('root', null, logs);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet, logs);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet, logs);
    RouterOutlet gameAdvancedOutlet =
        new MockOutlet('advanced', gameDetailOutlet, logs);

    location.register(rootOutlet, ['games']);
    location.register(gamesOutlet, [':id']);
    location.register(gameDetailOutlet, ['']);
    location.register(gameAdvancedOutlet, ['']);

    location.url = 'extranet/games/12';

    expect(
        logs,
        equals([
          'activate(root) games {}',
          'activate(games) :id {id: 12}',
          'activate(detail)  {}',
          'activate(advanced)  {}',
        ]));
    logs.clear();

    RouterOutlet gameEvenMoreAdvancedOutlet =
        new MockOutlet('more-advanced', gameAdvancedOutlet, logs);
    location.register(gameEvenMoreAdvancedOutlet, ['']);
    location.url = 'extranet/games/12';

    expect(
        logs,
        equals([
          'activate(more-advanced)  {}',
        ]));
  });

  test('Location with default not at end', () {
    Location location = new Location()..base = 'extranet';

    List<String> logs = [];
    RouterOutlet rootOutlet = new MockOutlet('root', null, logs);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet, logs);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet, logs);
    RouterOutlet gameAdvancedOutlet =
        new MockOutlet('advanced', gameDetailOutlet, logs);

    location.register(rootOutlet, ['games', '']);
    location.register(gamesOutlet, ['', ':id']);
    location.register(gameDetailOutlet, ['']);
    location.register(gameAdvancedOutlet, ['']);

    location.url = 'extranet/games/12';

    expect(
        logs,
        equals([
          'activate(root) games {}',
          'activate(games) :id {id: 12}',
          'activate(detail)  {}',
          'activate(advanced)  {}',
        ]));
    logs.clear();

    RouterOutlet gameEvenMoreAdvancedOutlet =
        new MockOutlet('more-advanced', gameAdvancedOutlet, logs);
    location.register(gameEvenMoreAdvancedOutlet, ['']);
    location.url = 'extranet/games/12';

    expect(
        logs,
        equals([
          'activate(more-advanced)  {}',
        ]));
  });

  test('Sort', () {
    List<PathPattern> paths = [
      new PathPattern(''),
      new PathPattern('a'),
      new PathPattern(''),
      new PathPattern('b'),
      new PathPattern(''),
      new PathPattern('')
    ];

    var sorted = OutletHolder.sortPaths(paths);

    expect(
        sorted,
        equals([
          new PathPattern('a'),
          new PathPattern('b'),
          new PathPattern(''),
          new PathPattern(''),
          new PathPattern(''),
          new PathPattern('')
        ]));
  });
}

class MockOutlet implements RouterOutlet {
  final String name;
  final RouterOutlet parent;
  final List<String> logger;
  String currentPath;

  MockOutlet(this.name, this.parent, this.logger);

  @override
  activate(Peek peek, Route route) {
    currentPath = peek.joinedSegments;
    logger.add('activate($name) ${peek.pattern.original} ${route.parameters}');
  }

  @override
  deactivate(String path) {
    logger.add('deactivate($name) $path');
  }
}
