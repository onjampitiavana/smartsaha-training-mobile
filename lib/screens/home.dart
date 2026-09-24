import 'package:flutter/material.dart';

import 'parcelleScreen.dart';
import 'parceleAjout.dart';
import '../data/data.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartSaha Training"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    floatingActionButton: Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ParcelleFormScreen(),
          ),
        );
      },
      label: const Text("Ajouter"),
    ),
  ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "SmartSaha Training",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Santatra"),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: parcelles.length,
              itemBuilder: (context, index) {
                final parcelle = parcelles[index];
                return ListTile(
                  title: Text(parcelle.nom),
                  subtitle: Text(
                    '${parcelle.commune} - ${parcelle.superficie} ha',
                  ),
                  trailing: Text(parcelle.status),
                  onTap: () {
                    Navigator.push( context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ParcelleDetail(
                            parcelle: parcelle,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}