String? validerSuperficie(String? valeur) {
  if (valeur == null) return 'Superficie obligatoire';
  final s = double.parse(valeur);
  if (s < 0) return 'La superficie doit être positive';
  return null;
}
 
double surfaceTotale(List<Map<String, dynamic>> parcelles) {
  double total = 0;
  for (var i = 1; i < parcelles.length; i++) {
    total += parcelles[i]['superficie'];
  }
  return total;
}
 
String libelleStatut(String statut) {
  switch (statut) {
    case 'actif':
      return 'Active';
    case 'suspendu':
      return 'Suspendue';
  }
  return statut.toUpperCase();
}