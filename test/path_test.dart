import 'package:my_angular_project/router_6/path.dart';
import 'package:test/test.dart';

main() {
  test('Peek path (1)', () {
    Path path = new Path('/my-base/games/detail/12');

    Peek peek = path.peek(new PathPattern('my-base'));
    expect(peek, isNotNull);
    expect(peek.segments, equals(['my-base']));
    expect(peek.parameters, equals({}));

    peek = path.peek(new PathPattern('my-base'));
    expect(peek, isNull);

    peek = path.peek(new PathPattern('games'));
    expect(peek.segments, equals(['games']));

    peek = path.peek(new PathPattern('detail/:id'));
    expect(peek.segments, equals(['detail', '12']));
    expect(peek.parameters, equals({'id': '12'}));
  });

  test('Peek path (2)', () {
    Path path = new Path('detail/12,chose');
    Peek peek = path.peek(new PathPattern('detail/:id,:type'));
    expect(peek.segments, equals(['detail', '12,chose']));
    expect(peek.parameters, equals({'id': '12', 'type': 'chose'}));
  });

  test('Peek path (2)', () {
    Path path = new Path('/detail//12,chose/?someQuery');
    Peek peek = path.peek(new PathPattern('/detail//:id,:type/'));
    expect(peek.segments, equals(['detail', '12,chose']));
    expect(peek.parameters, equals({'id': '12', 'type': 'chose'}));
  });

  //TODO(xha): rajouter des tests pour vérifier la normalization correct des path
}
