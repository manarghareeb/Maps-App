import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/map/domain/entities/direction_entity.dart';
import 'package:maps_app/features/map/domain/repositories/user_location_repository.dart';

class GetDirectionsUseCase {
  final UserLocationRepository repository;
  GetDirectionsUseCase({required this.repository});

  Future<Either<Failure, DirectionEntity>> call(LatLng start, LatLng end) {
    return repository.getDirections(start, end);
  }
}