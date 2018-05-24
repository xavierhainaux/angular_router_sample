import 'package:my_angular_project/router_6/location.dart';
import 'package:test/test.dart';

main() {
  test('Location life cycle', () {
    // 1. Un outlet enregistre tous les chemins défini et spécifiant son parent (ou le chemin complet?)
    //  => pour chaque enregistrement, on repasse dans la logique comme si l'url changait
    // 2. quand l'url change, on retrouve tous les paths et on regarde ceux qu'on doit instancier.
    // 3. On ne réactive jamais un path déjà instancié.
    // 4. un outlet détruit, dé-enregistre tous ces chemins.

    Location location = new Location('extranet');

    List<String> logs = [];
    RouterOutlet rootOutlet = new MockOutlet('root', null, logs);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet, logs);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet, logs);
    RouterOutlet gameAdvancedOutlet =
        new MockOutlet('advanced', gameDetailOutlet, logs);

    location.register(rootOutlet, 'dashboard');
    location.register(rootOutlet, 'games');
    location.register(gamesOutlet, 'list');
    location.register(gamesOutlet, ':id');
    location.register(gameDetailOutlet, '');
    location.register(gameAdvancedOutlet, 'advanced/:type');

    location.url = 'extranet/games/list';

    expect(
        logs,
        equals([
          'activate(root) games {}',
          'activate(games) list {}',
        ]));
    logs.clear();

    /*
    location.url = 'extranet/games';
    expect(logs, equals(['deactivate(games) list {}']));
    logs.clear();

    location.url = 'extranet/games/12/';
    expect(logs, equals(['activate(detail) :id {"id": "12"}']));
    logs.clear();

    location.url = 'extranet/games/12/advanced/machin';
    expect(
        logs, equals(['activate(advanced) advanced/:type {"type": "machin"}']));
    logs.clear();*/
  });
}

class MockOutlet implements RouterOutlet {
  final String name;
  final RouterOutlet parent;
  final List<String> logger;

  MockOutlet(this.name, this.parent, this.logger);

  @override
  onActivate(String path, Route route) {
    logger.add('activate($name) $path ${route.parameters}');
  }

  @override
  onDeactivate(String path) {
    logger.add('deactivate($name) $path');
  }
}
