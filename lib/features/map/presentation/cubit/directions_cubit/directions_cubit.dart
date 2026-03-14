import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/domain/usecases/fetch_route_osrm_usecase.dart';
import 'package:maps_app/features/map/domain/usecases/get_directions_usecase.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_state.dart';

class DirectionsCubit extends Cubit<DirectionsState> {
  final GetDirectionsUseCase getDirectionsUseCase;
  final FetchRouteFromOSRMUseCase fetchRouteFromOSRMUseCase;

  DirectionsCubit({required this.getDirectionsUseCase, required this.fetchRouteFromOSRMUseCase})
    : super(DirectionsInitial());

  Future<void> getDirections({
    required LatLng start,
    required LatLng end,
  }) async {
    emit(DirectionsLoading());

    final result = await getDirectionsUseCase(start, end);

    result.fold(
      (failure) {
        emit(DirectionsError(failure.message));
      },
      (directions) {
        log('directions $directions');
        emit(DirectionsSuccess(directions));
      },
    );
  }

  Future<void> fetchRouteFromOSRM({
    required LatLng start,
    required LatLng end,
  }) async {
    emit(DirectionsLoading());
    final result = await fetchRouteFromOSRMUseCase(start, end);

    result.fold(
      (failure) => emit(DirectionsError(failure.message)),
      (points) {
        log('OSRM route points: $points');
        emit(MapPolylineLoaded(points));
      },
    );
  }

  void clearDirections() {
    emit(DirectionsCleared());
  }
}
