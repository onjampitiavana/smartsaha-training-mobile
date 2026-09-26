import 'package:flutter/material.dart';
import '../api/service.dart';
import '../models/parcelle.dart';

class ParcelleFormScreen extends StatefulWidget {
  const ParcelleFormScreen({super.key});

  @override
  State<ParcelleFormScreen> createState() => _ParcelleFormScreenState();
}

class _ParcelleFormScreenState extends State<ParcelleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final agriculteurController = TextEditingController();
  final communeController = TextEditingController();
  final superficieController = TextEditingController();
  final cultureController = TextEditingController();
  final observationController = TextEditingController();

  final service = Service();
  bool loading = false;

  @override
  void dispose() {
    nomController.dispose();
    agriculteurController.dispose();
    communeController.dispose();
    superficieController.dispose();
    cultureController.dispose();
    observationController.dispose();
    super.dispose();
  }

  Future<void> enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final parcelle = Parcelle(
        id: '',
        nom: nomController.text,
        agriculteur: agriculteurController.text,
        commune: communeController.text,
        superficie: double.parse(
          superficieController.text.replaceAll(',', '.'),
        ),
        status: 'active',
        culture: cultureController.text,
        observation: observationController.text,
      );

      await service.createParcelle(parcelle);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parcelle enregistrée')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une parcelle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de la parcelle',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: agriculteurController,
              decoration: const InputDecoration(
                labelText: 'Agriculteur',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer l\'agriculteur';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: communeController,
              decoration: const InputDecoration(
                labelText: 'Commune',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la commune';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: superficieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Superficie (ha)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la superficie';
                }
                final nombre = double.tryParse(
                  value.replaceAll(',', '.'),
                );
                if (nombre == null || nombre <= 0) {
                  return 'Superficie invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: cultureController,
              decoration: const InputDecoration(
                labelText: 'Culture',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la culture';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: observationController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : enregistrer,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('ENREGISTRER'),
            ),
          ],
        ),
      ),
    );
  }
}