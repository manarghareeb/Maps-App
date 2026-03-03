import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/map/domain/entities/direction_entity.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';

abstract class UserLocationRepository {
  Future<Either<Failure, UserLocationEntity>> getCurrentLocation();
  Future<Either<Failure, DirectionEntity>> getDirections(LatLng start, LatLng end);
  Future<Either<Failure, List<LatLng>>> fetchRouteFromOSRM(LatLng start, LatLng end);
}