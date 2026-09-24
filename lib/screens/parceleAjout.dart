import 'package:flutter/material.dart';

class ParcelleFormScreen extends StatefulWidget {
  const ParcelleFormScreen({super.key});

  @override
  State<ParcelleFormScreen> createState() {
    return _ParcelleFormScreenState();
  }
}

class _ParcelleFormScreenState extends State<ParcelleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _agriculteurController = TextEditingController();
  final _communeController = TextEditingController();
  final _superficieController = TextEditingController();
  final _cultureController = TextEditingController();
  final _observationController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _agriculteurController.dispose();
    _communeController.dispose();
    _superficieController.dispose();
    _cultureController.dispose();
    _observationController.dispose();
    super.dispose();
  }
  //gestion formulaire
String? _validerTexte(String? value, String nomChamp){
    if(value == null || value.trim().isEmpty){
        return 'invalid';
    }
    return null;
}
String? _valideSuperficie(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'superficie null';
  }
  final valeur = value.trim().replaceAll(',', '.');
  final superficie = double.tryParse(valeur);
  if (superficie == null) {
    return 'invalid';
  }
  if (superficie <= 0) {
    return 'superficie doit etre positif';
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une parcelle'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la parcelle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
  return _validerTexte(value, 'invalid');
},
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _agriculteurController,
                decoration: const InputDecoration(
                  labelText: 'Agriculteur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                    return _validerTexte(value, "invalid");
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _communeController,
                decoration: const InputDecoration(
                  labelText: 'Commune',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
            return _validerTexte(value, 'invalid');
                  },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _superficieController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Superficie (ha)',
                  border: OutlineInputBorder(),
                ),
                validator: _valideSuperficie,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cultureController,
                decoration: const InputDecoration(
                  labelText: 'Culture',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                return _validerTexte(value, 'invalid');
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observationController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     if (_formKey.currentState!.validate()) {
                            print('Formulaire valide');
                         }
                        },
                    child: const Text('ENREGISTRER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}