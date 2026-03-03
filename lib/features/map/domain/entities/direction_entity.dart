import 'package:latlong2/latlong.dart';

class DirectionEntity {
  final List<LatLng> points;
  final double distance;
  final double duration;

  DirectionEntity({
    required this.points,
    required this.distance,
    required this.duration,
  });
}