import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/map/domain/repositories/user_location_repository.dart';

class GetAddressFromLatlngUsecase {
  final UserLocationRepository repository;
  GetAddressFromLatlngUsecase({required this.repository});

  Future<Either<Failure, String>> call(LatLng position) async {
    return await repository.getAddressFromLatLng(position);
  }
}
