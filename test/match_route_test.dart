import 'package:test/test.dart';

main() {
  // Des tests bas niveau pour valider que les match d'url marchent bien

  test('Match urls', () {
    expectMatch(['root', 'category/:type'], 'root/category/dice',
        ['root', 'category/{"type": "dice"}']);
  });
}
