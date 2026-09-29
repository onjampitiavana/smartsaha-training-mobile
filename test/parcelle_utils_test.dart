import 'package:flutter_test/flutter_test.dart';
import '../lib/training/parcelle_utils.dart';

void main() {
  group('validerSuperficie', () {
    test('superficie vide', () {
      expect(
        validerSuperficie(''),
        'Superficie obligatoire',
      );
    });

    test('superficie 2.5', () {
      expect(
        validerSuperficie('2.5'),
        isNull,
      );
    });
  });

  test('calcule le total des parcelles', () {
    final parcelles = [
      {'superficie': 2.5},
      {'superficie': 3.0},
      {'superficie': 1.5},
    ];

    expect(
      surfaceTotale(parcelles),
      7.0,
    );
  });
}