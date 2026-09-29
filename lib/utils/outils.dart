double? lireNombre(String? valeur) =>
    double.tryParse((valeur ?? '').trim().replaceAll(',', '.'));

bool latitudeValide(double lat) => lat >= -90 && lat <= 90;

bool longitudeValide(double lon) => lon >= -180 && lon <= 180;

bool horsMadagascar(double lat, double lon) =>
    lat < -26 || lat > -11 || lon < 43 || lon > 51;