import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.name,
    required super.lat,
    required super.lng,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['display_name'] ?? "Unknown Location",
      lat: double.parse(json['lat']),
      lng: double.parse(json['lon']),
    );
  }
}