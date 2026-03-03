import 'package:latlong2/latlong.dart';
import '../../domain/entities/direction_entity.dart';

class DirectionModel extends DirectionEntity {
  DirectionModel({required super.points, required super.distance, required super.duration});

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    final route = json['features'][0];
    final List<dynamic> coords = route['geometry']['coordinates'];
    
    List<LatLng> points = coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();

    return DirectionModel(
      points: points,
      distance: route['properties']['summary']['distance'] / 1000,
      duration: route['properties']['summary']['duration'] / 60,
    );
  }
}