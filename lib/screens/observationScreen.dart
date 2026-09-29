import 'package:flutter/material.dart';

import '../api/observation_service.dart';
import '../models/observation.dart';
import 'Observation_Ajout.dart';

class ObservationScreen extends StatefulWidget {
  const ObservationScreen({super.key});

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  final service = ObservationService();

  List<Observation> observations = [];
  bool isLoading = true;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    chargerObservations();
  }

  Future<void> chargerObservations() async {
    setState(() => isLoading = true);

    final locales = await service.getLocal();
    final serveur = await service.getServeur();

    final resultat = serveur == null
        ? locales
        : [
            ...serveur,
            ...locales.where((l) => !serveur.any((s) => s.id == l.id)),
          ];

    if (!mounted) return;
    setState(() {
      observations = resultat;
      isLoading = false;
    });
  }

  Future<void> synchroniser() async {
    setState(() => isSyncing = true);

    final envoyees = await service.synchroniser();
    await chargerObservations();

    if (!mounted) return;
    setState(() => isSyncing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          envoyees > 0
              ? '$envoyees observation(s) synchronisée(s)'
              : 'Rien à synchroniser ou pas de connexion',
        ),
      ),
    );
  }

  Future<void> ouvrirAjout() async {
    final resultat = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ObservationAjout()),
    );
    if (resultat == true) chargerObservations();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Observations'),
      actions: [
        TextButton.icon(
          onPressed: ouvrirAjout,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
        ),
        IconButton(
          onPressed: isSyncing ? null : synchroniser,
          icon: const Icon(Icons.sync),
          tooltip: 'Synchroniser',
        ),
      ],
    ),
    body: corps(),
  );
}

  Widget corps() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (observations.isEmpty) {
      return const Center(
        child: Text(
          'Aucune observation pour le moment',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: chargerObservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: observations.length,
        itemBuilder: (context, index) => carte(observations[index]),
      ),
    );
  }

  Widget carte(Observation obs) {
    final enAttente = obs.status == 'en_attente';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(obs.agriculteur),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Parcelle : ${obs.parcelle}'),
            Text('Commune : ${obs.commune}'),
            Text('Culture : ${obs.culture}'),
            Text('Date : ${obs.date.split('T').first}'),
            Text('Observation : ${obs.observation}'),
            const SizedBox(height: 5),
            Text(
              enAttente ? 'En attente de synchronisation' : 'Synchronisée',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: enAttente ? Colors.orange : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}