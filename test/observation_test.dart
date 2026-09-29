import 'package:flutter_test/flutter_test.dart';
import 'package:smartsaha/models/observation.dart';
import 'package:smartsaha/utils/outils.dart';

void main() {
  const obs = Observation(
    id: 'obs-1',
    agriculteur: 'Rakoto',
    parcelle: 'P1',
    commune: 'Ambohidratrimo',
    culture: 'Riz',
    superficie: 1.5,
    latitude: -18.9,
    longitude: 47.5,
    date: '2026-09-29T10:00:00',
    observation: 'RAS',
  );

  test('toJson puis fromJson conserve les données', () {
    final copie = Observation.fromJson(obs.toJson());
    expect(copie.id, obs.id);
    expect(copie.superficie, 1.5);
    expect(copie.status, 'en_attente');
  });

  test('copyWith modifie uniquement le statut', () {
    final copie = obs.copyWith(status: 'synchronisee');
    expect(copie.status, 'synchronisee');
    expect(copie.id, obs.id);
  });

  test('lireNombre accepte la virgule', () {
    expect(lireNombre('1,5'), 1.5);
    expect(lireNombre('abc'), isNull);
  });

  test('bornes de latitude et longitude', () {
    expect(latitudeValide(95), isFalse);
    expect(latitudeValide(-18.9), isTrue);
    expect(longitudeValide(-200), isFalse);
    expect(longitudeValide(47.5), isTrue);
  });

  test('détection hors Madagascar', () {
    expect(horsMadagascar(-18.9, 47.5), isFalse);
    expect(horsMadagascar(48.8, 2.3), isTrue);
  });
}