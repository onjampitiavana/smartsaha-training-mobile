import 'dart:convert';
import 'package:http/http.dart' as http;
import './config.dart';
import '../models/parcelle.dart';
class Service{
   Future<List<Parcelle>> getParcelle() async {
  print('Appel  GET/parcelles');

  final response = await http
      .get(Uri.parse('${Config.url}/parcelles'))
      .timeout(const Duration(seconds: 10));

  print('status: ${response.statusCode}');
  print('body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Parcelle.fromJson(json))
        .toList();
  } else {
    throw Exception("Impossible de recuperer les parcelles");
  }
}
        Future<void> createParcelle(Parcelle parcelle) async{
            final response = await http
            .post(Uri.parse('${Config.url}/parcelles'),
            headers:{
                'Content-Type':"application/json",
            },
            body:jsonEncode(parcelle.toJson()),)
            .timeout(const Duration(seconds:10),);
            if(response.statusCode != 201){
                throw Exception("Impossible d'enregistrer");
            }
        
    }
}