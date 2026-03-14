import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final UserLocationEntity location;
  MapSuccess(this.location);
}

class MapAddressSuccess extends MapSuccess {
  final String address;
  final LatLng position;

  MapAddressSuccess({
    required this.address, 
    required this.position, 
    required UserLocationEntity location,
  }) : super(location);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
