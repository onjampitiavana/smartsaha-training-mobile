class Observation {
  final String id;
  final String agriculteur;
  final String parcelle;
  final String commune;
  final String culture;
  final double superficie;
  final double latitude;
  final double longitude;
  final String date;
  final String observation;
  final String status;

  const Observation({
    required this.id,
    required this.agriculteur,
    required this.parcelle,
    required this.commune,
    required this.culture,
    required this.superficie,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.observation,
    this.status = 'en_attente',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'agriculteur': agriculteur,
        'parcelle': parcelle,
        'commune': commune,
        'culture': culture,
        'superficie': superficie,
        'latitude': latitude,
        'longitude': longitude,
        'date': date,
        'observation': observation,
        'status': status,
      };

  factory Observation.fromJson(Map<String, dynamic> json) => Observation(
        id: json['id'].toString(),
        agriculteur: json['agriculteur'] ?? '',
        parcelle: json['parcelle'] ?? '',
        commune: json['commune'] ?? '',
        culture: json['culture'] ?? '',
        superficie: (json['superficie'] as num).toDouble(),
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        date: json['date'] ?? '',
        observation: json['observation'] ?? '',
        status: json['status'] ?? 'en_attente',
      );

  Observation copyWith({String? status}) => Observation(
        id: id,
        agriculteur: agriculteur,
        parcelle: parcelle,
        commune: commune,
        culture: culture,
        superficie: superficie,
        latitude: latitude,
        longitude: longitude,
        date: date,
        observation: observation,
        status: status ?? this.status,
      );
}