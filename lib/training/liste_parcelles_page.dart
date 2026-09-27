import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
class ListeParcellesPage extends StatefulWidget {
  const ListeParcellesPage({super.key});
 
  @override
  State<ListeParcellesPage> createState() => _ListeParcellesPageState();
}
 
class _ListeParcellesPageState extends State<ListeParcellesPage> {
  List parcelles = [];
  bool chargement = true;
 
  @override
  void initState() {
    super.initState();
    charger();
  }
 
  Future<void> charger() async {
    //final res = await http.get(Uri.parse('http://localhost:3000/parcelles'));
    final res = await http.get(Uri.parse('http://10.0.2.2:3000/parcelles'));
    setState((){
      parcelles = jsonDecode(res.body);
      chargement=false;
    });
   //parcelles = jsonDecode(res.body);
  // chargement = false;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parcelles (J5)')),
      body: chargement
          ? const Center(child: CircularProgressIndicator())
         // : ListView.builder(itemCount: parcelles.length + 1,
          : ListView.builder(itemCount: parcelles.length ,
              itemBuilder: (context, i) => ListTile(
                title: Text(parcelles[i]['nom']),
                subtitle: Text('${parcelles[i]['superficie']} ha'),
              ),
            ),
    );
  }
}