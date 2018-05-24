import 'package:my_angular_project/router_6/location.dart';
import 'package:test/test.dart';

main() {
  // Des tests bas niveau pour valider que les match d'url marchent bien

  test('Match urls', () {
    RouterOutlet rootOutlet = new MockOutlet('root', null);
    RouterOutlet dashboardOutlet = new MockOutlet('dashboard', rootOutlet);
    RouterOutlet gamesOutlet = new MockOutlet('games', rootOutlet);
    RouterOutlet gameDetailOutlet = new MockOutlet('detail', gamesOutlet);

    Location location = new Location()..base = 'extranet';
    location.register(rootOutlet, ['dashboard', 'games']);
    location.register(dashboardOutlet, ['create', 'list', 'update']);
    location.register(gamesOutlet, ['list', 'detail/:id']);
    location.register(gameDetailOutlet, ['related', 'advanced/:type']);

    expectMatch(location, 'extranet/dashboard', 'dashboard');

    expectMatch(
        location, 'extranet/games/detail/12', 'games|detail/{"id":"12"}');

    expectMatch(location, 'extranet/dashboard/create', 'dashboard|create');

    expectMatch(location, 'extranet/games/detail/12/advanced/MyCategory',
        'games|detail/{"id":"12"}|advanced/{"type":"MyCategory"}');
  });
}

expectMatch(Location location, String url, String expected) {
  List<MatchedEntry> entries = location.getMatchedEntries(url);

  String result = entries.map((e) => e.toString()).join('|');

  expect(result, equals(expected));
}

class MockOutlet implements RouterOutlet {
  final String name;
  final RouterOutlet parent;
  String currentPath;

  MockOutlet(this.name, this.parent);

  @override
  activate(Peek path, Route route) {
    currentPath = path.joinedSegments;
  }

  @override
  deactivate(String path) {}
}
