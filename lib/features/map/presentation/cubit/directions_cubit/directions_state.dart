import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/domain/entities/direction_entity.dart';

abstract class DirectionsState {}

class DirectionsInitial extends DirectionsState {}

class DirectionsLoading extends DirectionsState {}

class DirectionsSuccess extends DirectionsState {
  final DirectionEntity directions;
  DirectionsSuccess(this.directions);
}
class MapPolylineLoaded extends DirectionsState {
  final List<LatLng> polyline;
  MapPolylineLoaded(this.polyline);
}

class DirectionsError extends DirectionsState {
  final String message;
  DirectionsError(this.message);
}

class DirectionsCleared extends DirectionsState {} 