import 'dart:convert';

class PlaceEntity {
  final String name;
  final double lat;
  final double lng;

  PlaceEntity({required this.name, required this.lat, required this.lng});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
  }

  factory PlaceEntity.fromMap(Map<String, dynamic> map) {
    return PlaceEntity(
      name: map['name'] ?? '',
      lat: map['lat'] ?? 0.0,
      lng: map['lng'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceEntity.fromJson(String source) => PlaceEntity.fromMap(json.decode(source));
}