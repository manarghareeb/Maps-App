import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';
import 'package:maps_app/features/map/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:maps_app/features/map/domain/usecases/get_current_location_usecase.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromLatlngUsecase getAddressFromLatLngUseCase;
  MapCubit({
    required this.getCurrentLocationUseCase,
    required this.getAddressFromLatLngUseCase,
  }) : super(MapInitial());

  Future<void> fetchCurrentLocation() async {
    emit(MapLoading());
    final result = await getCurrentLocationUseCase();

    result.fold(
      (failure) {
        log('Error fetching location: ${failure.message}');
        emit(MapError(failure.message));
      },
      (location) {
        log(
          'Location fetched successfully: ${location.latitude}, ${location.longitude}',
        );
        emit(MapSuccess(location));
      },
    );
  }

  void moveToLocation(double lat, double lng) {
    emit(MapSuccess(UserLocationEntity(latitude: lat, longitude: lng)));
  }

  Future<void> getAddress(LatLng position) async {
    UserLocationEntity? currentLocation;
    if (state is MapSuccess) {
      currentLocation = (state as MapSuccess).location;
    }
    emit(MapLoading());
    final result = await getAddressFromLatLngUseCase(position);
    result.fold(
      (failure) => emit(MapError(failure.message)),
      (address) {
        emit(MapAddressSuccess(
          address: address,
          position: position,
          location: currentLocation ?? UserLocationEntity(latitude: position.latitude, longitude: position.longitude),
        ));
      },
    );
  }
}
