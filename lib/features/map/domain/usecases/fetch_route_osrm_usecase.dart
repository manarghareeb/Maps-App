import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/errors/failures.dart';
import '../repositories/user_location_repository.dart';

class FetchRouteFromOSRMUseCase {
  final UserLocationRepository repository;

  FetchRouteFromOSRMUseCase({required this.repository});

  Future<Either<Failure, List<LatLng>>> call(LatLng start, LatLng end) async {
    return repository.fetchRouteFromOSRM(start, end);
  }
}