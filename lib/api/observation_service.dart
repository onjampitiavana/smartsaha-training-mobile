import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/observation.dart';
import 'config.dart';

enum ResultatEnvoi { succes, horsLigne, erreurServeur }

class ObservationService {
  static const _cle = 'observations_locales';
  static const _entetes = {'Content-Type': 'application/json'};
  static const _delai = Duration(seconds: 5);

  Uri _uri([String chemin = '']) =>
      Uri.parse('${Config.url}/observations$chemin');

  Future<List<Observation>> getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final brut = prefs.getStringList(_cle) ?? [];
    return brut.map((e) => Observation.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _ecrireLocal(List<Observation> liste) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _cle,
      liste.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> sauvegarder(Observation obs) async {
    final liste = await getLocal();
    if (liste.any((e) => e.id == obs.id)) return;
    await _ecrireLocal([...liste, obs]);
  }

  Future<List<Observation>?> getServeur() async {
    try {
      final reponse = await http.get(_uri()).timeout(_delai);
      if (reponse.statusCode != 200) return null;
      final donnees = jsonDecode(reponse.body) as List;
      return donnees.map((e) => Observation.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> _existe(String id) async {
    try {
      final reponse = await http.get(_uri('/$id')).timeout(_delai);
      return reponse.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<ResultatEnvoi> envoyer(Observation obs) async {
    try {
      final reponse = await http
          .post(
            _uri(),
            headers: _entetes,
            body: jsonEncode(obs.copyWith(status: 'synchronisee').toJson()),
          )
          .timeout(_delai);

      if (reponse.statusCode == 200 || reponse.statusCode == 201) {
        return ResultatEnvoi.succes;
      }
      if (await _existe(obs.id)) return ResultatEnvoi.succes;
      return ResultatEnvoi.erreurServeur;
    } catch (_) {
      return ResultatEnvoi.horsLigne;
    }
  }

  Future<int> synchroniser() async {
    final liste = await getLocal();
    final restantes = <Observation>[];
    var envoyees = 0;

    for (var i = 0; i < liste.length; i++) {
      final resultat = await envoyer(liste[i]);
      if (resultat == ResultatEnvoi.succes) {
        envoyees++;
        continue;
      }
      restantes.add(liste[i]);
      if (resultat == ResultatEnvoi.horsLigne) {
        restantes.addAll(liste.sublist(i + 1));
        break;
      }
    }

    await _ecrireLocal(restantes);
    return envoyees;
  }
}