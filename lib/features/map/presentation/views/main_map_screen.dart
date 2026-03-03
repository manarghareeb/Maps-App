import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_state.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';
import 'package:maps_app/features/search/presentation/views/search_bar_widget.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  final MapController mapController = MapController();

  LatLng? startPoint;
  LatLng? endPoint;
  List<LatLng> routePoints = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MapCubit, MapState>(
            builder: (context, mapState) {
              if (mapState is MapSuccess && startPoint == null) {
                startPoint = LatLng(
                  mapState.location.latitude,
                  mapState.location.longitude,
                );
              }

              return BlocBuilder<DirectionsCubit, DirectionsState>(
                builder: (context, directionsState) {
                  if (directionsState is DirectionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (directionsState is MapPolylineLoaded) {
                    routePoints = directionsState.polyline;
                  }

                  return FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter:
                          startPoint ?? const LatLng(30.0444, 31.2357),
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.maps_app',
                      ),

                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              strokeWidth: 5.0,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),

                      MarkerLayer(
                        markers: [
                          if (startPoint != null)
                            Marker(
                              point: startPoint!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                          if (endPoint != null)
                            Marker(
                              point: endPoint!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: SearchBarWidget(
              onPlaceSelected: (placeName, lat, lng) {
                _onPlaceSelected(lat, lng);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "loc_btn",
        backgroundColor: Colors.white,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          final mapState = context.read<MapCubit>().state;
          if (mapState is MapSuccess) {
            final currentLat = mapState.location.latitude;
            final currentLng = mapState.location.longitude;
            final currentLocation = LatLng(currentLat, currentLng);

            await Future.delayed(const Duration(milliseconds: 500));
            mapController.move(currentLocation, 15.0);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Waiting for current location...'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.blue,))
        : const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  void _onPlaceSelected(double lat, double lng) {
    final mapState = context.read<MapCubit>().state;

    if (mapState is MapSuccess) {
      final currentLat = mapState.location.latitude;
      final currentLng = mapState.location.longitude;

      if (currentLat == 0 && currentLng == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waiting for current location...'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      startPoint = LatLng(currentLat, currentLng);
      endPoint = LatLng(lat, lng);

      if (startPoint != endPoint) {
        context.read<DirectionsCubit>().fetchRouteFromOSRM(
          start: startPoint!,
          end: endPoint!,
        );
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints([startPoint!, endPoint!]),
            padding: const EdgeInsets.all(50),
          ),
        );
      } else {
        mapController.move(startPoint!, 15.0);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waiting for current location...'),
        ),
      );
    }
  }
}
