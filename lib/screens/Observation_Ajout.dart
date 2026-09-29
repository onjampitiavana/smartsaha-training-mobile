import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/observation_service.dart';
import '../models/observation.dart';
import '../utils/outils.dart';

class ObservationAjout extends StatefulWidget {
  const ObservationAjout({super.key});

  @override
  State<ObservationAjout> createState() => _ObservationAjoutState();
}

class _ObservationAjoutState extends State<ObservationAjout> {
  final formKey = GlobalKey<FormState>();
  final service = ObservationService();

  final agriculteur = TextEditingController();
  final parcelle = TextEditingController();
  final commune = TextEditingController();
  final culture = TextEditingController();
  final superficie = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final observation = TextEditingController();

  DateTime date = DateTime.now();
  bool sending = false;

  @override
  void dispose() {
    for (final c in [
      agriculteur,
      parcelle,
      commune,
      culture,
      superficie,
      latitude,
      longitude,
      observation,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void afficher(String texte) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texte)),
    );
  }

  Future<void> choisirDate() async {
    final choix = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (choix != null) setState(() => date = choix);
  }

  Future<void> positionAuto() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        afficher('Activez le GPS du téléphone');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        afficher('Permission de localisation refusée');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      latitude.text = position.latitude.toStringAsFixed(6);
      longitude.text = position.longitude.toStringAsFixed(6);
    } catch (_) {
      afficher('Impossible de récupérer la position');
    }
  }

  Future<bool> confirmerHorsMadagascar() async {
    final reponse = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Coordonnées suspectes'),
        content: const Text(
          'Ces coordonnées semblent hors de Madagascar. Continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Corriger'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
    return reponse == true;
  }

  Future<void> enregistrer() async {
    if (!formKey.currentState!.validate()) return;

    final lat = lireNombre(latitude.text)!;
    final lon = lireNombre(longitude.text)!;

    setState(() => sending = true);

    if (horsMadagascar(lat, lon) && !await confirmerHorsMadagascar()) {
      if (mounted) setState(() => sending = false);
      return;
    }

    final data = Observation(
      id: 'obs-${DateTime.now().microsecondsSinceEpoch}',
      agriculteur: agriculteur.text.trim(),
      parcelle: parcelle.text.trim(),
      commune: commune.text.trim(),
      culture: culture.text.trim(),
      superficie: lireNombre(superficie.text)!,
      latitude: lat,
      longitude: lon,
      date: date.toIso8601String(),
      observation: observation.text.trim(),
    );

    final resultat = await service.envoyer(data);
    if (resultat != ResultatEnvoi.succes) await service.sauvegarder(data);

    if (!mounted) return;
    setState(() => sending = false);

    afficher(switch (resultat) {
      ResultatEnvoi.succes => 'Observation enregistrée et synchronisée',
      ResultatEnvoi.horsLigne =>
        'Pas de connexion : observation gardée en attente',
      ResultatEnvoi.erreurServeur =>
        'Erreur du serveur : observation gardée en attente',
    });

    Navigator.pop(context, true);
  }

  String? obligatoire(String? v) =>
      v == null || v.trim().isEmpty ? 'Champ obligatoire' : null;

  String? nombre(String? v) {
    final n = lireNombre(v);
    return n == null || n <= 0 ? 'Nombre invalide' : null;
  }

  String? validerLatitude(String? v) {
    final n = lireNombre(v);
    return n == null || !latitudeValide(n) ? 'Latitude invalide' : null;
  }

  String? validerLongitude(String? v) {
    final n = lireNombre(v);
    return n == null || !longitudeValide(n) ? 'Longitude invalide' : null;
  }

  Widget champ(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? clavier,
    int lignes = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: clavier,
        maxLines: lignes,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const decimal = TextInputType.numberWithOptions(decimal: true);
    const decimalSigne =
        TextInputType.numberWithOptions(decimal: true, signed: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une observation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              champ('Agriculteur', agriculteur, validator: obligatoire),
              champ('Parcelle', parcelle, validator: obligatoire),
              champ('Commune', commune, validator: obligatoire),
              champ('Culture', culture, validator: obligatoire),
              champ(
                'Superficie (ha)',
                superficie,
                validator: nombre,
                clavier: decimal,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: choisirDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      'Date : ${date.day}/${date.month}/${date.year}',
                    ),
                  ),
                ),
              ),
              champ(
                'Latitude',
                latitude,
                validator: validerLatitude,
                clavier: decimalSigne,
              ),
              champ(
                'Longitude',
                longitude,
                validator: validerLongitude,
                clavier: decimalSigne,
              ),
              champ(
                'Observation',
                observation,
                validator: obligatoire,
                lignes: 4,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: sending ? null : enregistrer,
                  child: Text(sending ? 'Envoi...' : 'Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}