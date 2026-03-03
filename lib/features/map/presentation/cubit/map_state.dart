import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final UserLocationEntity location;
  MapSuccess(this.location);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
