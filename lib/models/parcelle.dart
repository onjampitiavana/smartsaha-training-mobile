class Parcelle {
  final String nom;
  final String agriculteur;
  final String commune;
  final double superficie;
  final String status;
  final String culture;
  final String observation;

  const Parcelle({
    required this.nom,
    required this.agriculteur,
    required this.commune,
    required this.superficie,
    required this.status,
    required this.culture,
    required this.observation,
  });
}