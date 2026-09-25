import 'package:flutter/material.dart';

import 'parcelleScreen.dart';
import 'parceleAjout.dart';
import '../api/service.dart';
import '../models/parcelle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Service service = Service();

  List<Parcelle> parcelles = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    chargerParcelles();
  }

  Future<void> chargerParcelles() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await service.getParcelle();

      if (!mounted) return;

      setState(() {
        parcelles = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = true;
        parcelles = [];
      });
    }
  }

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
          onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ParcelleFormScreen(),
    ),
  );

  if (result == true) {
    chargerParcelles();
  }
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
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Impossible de récupérer les données.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: chargerParcelles,
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    if (parcelles.isEmpty) {
      return const Center(
        child: Text(
          "Aucune parcelle enregistrée.",
        ),
      );
    }

    return ListView.builder(
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
            Navigator.push(
              context,
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
    );
  }
}