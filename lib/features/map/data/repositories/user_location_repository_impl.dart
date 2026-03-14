import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/map/data/data_sources/map_remote_data_source.dart';
import 'package:maps_app/features/map/domain/entities/direction_entity.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';
import 'package:maps_app/features/map/domain/repositories/user_location_repository.dart';

class UserLocationRepositoryImpl implements UserLocationRepository {
  final MapRemoteDataSource remoteDataSource;

  UserLocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserLocationEntity>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(
          LocationFailure("Location services are disabled. Please enable GPS."),
        );
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(LocationFailure("Location permissions are denied."));
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Left(
          LocationFailure(
            "Location permissions are permanently denied. Please enable them from settings.",
          ),
        );
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return Right(
        UserLocationEntity(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (e) {
      return Left(
        LocationFailure("An unexpected error occurred: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, DirectionEntity>> getDirections(
    LatLng start,
    LatLng end,
  ) async {
    try {
      final result = await remoteDataSource.getDirections(start, end);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch the path from the server'));
    }
  }

  @override
  Future<Either<Failure, List<LatLng>>> fetchRouteFromOSRM(
      LatLng start, LatLng end) async {
    try {
      final route = await remoteDataSource.fetchRouteFromOSRM(start, end);
      if (route.isEmpty) {
        return Left(ServerFailure('No route found'));
      }
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return Right("${place.street}, ${place.locality}");
      }
      return Left(ServerFailure("Address not found"));
    } catch (e) {
      return Left(ServerFailure("Failed to get address"));
    }
  }
}
