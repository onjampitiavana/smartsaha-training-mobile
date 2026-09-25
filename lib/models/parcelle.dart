class Parcelle {
  final String id;
  final String nom;
  final String agriculteur;
  final String commune;
  final double superficie;
  final String status;
  final String culture;
  final String observation;

  const Parcelle({
    required this.id,
    required this.nom,
    required this.agriculteur,
    required this.commune,
    required this.superficie,
    required this.status,
    required this.culture,
    required this.observation,
  });

  factory Parcelle.fromJson(Map<String, dynamic> json) {
    return Parcelle(
      id: json['id'].toString(),
      nom: json['nom'] ?? '',
      agriculteur: json['agriculteur'] ?? '',
      commune: json['commune'] ?? '',
      superficie: (json['superficie'] as num).toDouble(),
      status: json['status'] ?? '',
      culture: json['culture'] ?? '',
      observation: json['observation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'agriculteur': agriculteur,
      'commune': commune,
      'superficie': superficie,
      'status': status,
      'culture': culture,
      'observation': observation,
    };
  }
}