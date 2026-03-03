import 'package:dartz/dartz.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';
import 'package:maps_app/features/map/domain/repositories/user_location_repository.dart';

class GetCurrentLocationUseCase {
  final UserLocationRepository repository;
  GetCurrentLocationUseCase({required this.repository});

  Future<Either<Failure, UserLocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
}