import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/features/map/domain/entities/user_location_entity.dart';
import 'package:maps_app/features/map/domain/usecases/get_current_location_usecase.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  MapCubit({required this.getCurrentLocationUseCase}) : super(MapInitial());

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
}
