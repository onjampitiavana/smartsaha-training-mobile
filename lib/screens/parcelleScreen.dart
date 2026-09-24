import 'package:flutter/material.dart';
import "../models/parcelle.dart";

class ParcelleDetail extends StatelessWidget {
  final Parcelle parcelle;

  const ParcelleDetail({
    super.key,
    required this.parcelle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail de parcelle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parcelle.nom,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Agriculteur : ${parcelle.agriculteur}'),
            const SizedBox(height: 8),
            Text('Commune : ${parcelle.commune}'),
            const SizedBox(height: 8),
            Text('Superficie : ${parcelle.superficie} ha'),
            const SizedBox(height: 8),
            Text('Statut : ${parcelle.status}'),
            const SizedBox(height: 8),
            Text('Culture : ${parcelle.culture}'),
            const SizedBox(height: 8),
            Text('Observation : ${parcelle.observation}'),
          ],
        ),
      ),
    );
  }
}