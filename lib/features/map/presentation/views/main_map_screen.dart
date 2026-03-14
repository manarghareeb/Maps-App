import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/directions_cubit/directions_state.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';
import 'package:maps_app/features/map/presentation/widgets/address_bottom_sheet.dart';
import 'package:maps_app/features/map/presentation/widgets/map_floating_buttons.dart';
import 'package:maps_app/features/map/presentation/widgets/map_top_search.dart';
import 'package:maps_app/features/map/presentation/widgets/map_view.dart';
import 'package:maps_app/features/map/presentation/widgets/route_selector.dart';
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

  bool isRouting = false;
  String? destinationName;
  String? startName;

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().fetchCurrentLocation();
  }

  void _openSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchBarWidget()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        destinationName = result['name'];
      });
      _onPlaceSelected(result['lat'], result['lng']);
    }
  }

  void _startDirectionFromPoint(LatLng point) {
    final mapState = context.read<MapCubit>().state;
    if (mapState is MapSuccess) {
      String placeName = "Destination";

      final addressState = context.read<MapCubit>().state;
      if (addressState is MapAddressSuccess) {
        placeName = addressState.address;
      }
      setState(() {
        endPoint = point;
        startPoint = LatLng(
          mapState.location.latitude,
          mapState.location.longitude,
        );
        isRouting = true;
        destinationName = placeName;
      });
      context.read<DirectionsCubit>().fetchRouteFromOSRM(
        start: startPoint!,
        end: endPoint!,
      );
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([startPoint!, endPoint!]),
          padding: const EdgeInsets.all(70),
        ),
      );
    }
  }

  Future<void> _selectPlace({required bool isStart}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchBarWidget()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (isStart) {
          startName = result['name'];
          startPoint = LatLng(result['lat'], result['lng']);
        } else {
          destinationName = result['name'];
          endPoint = LatLng(result['lat'], result['lng']);
        }
      });
      _drawRouteIfPointsExist();
    }
  }

  void _showAddressSheet(LatLng point) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return AddressBottomSheet(
          point: point,
          onStartDirection: _startDirectionFromPoint,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  return MapView(
                    mapController: mapController,
                    startPoint: startPoint,
                    endPoint: endPoint,
                    routePoints: routePoints,
                    onTap: (point) {
                      context.read<MapCubit>().getAddress(point);
                      _showAddressSheet(point);
                    },
                  );
                },
              );
            },
          ),
          MapTopSearch(
            isRouting: isRouting,
            onSearchTap: _openSearch,
            routeSelector: RouteSelector(
              startName: startName,
              destinationName: destinationName,
              onBack: () {
                setState(() {
                  isRouting = false;
                  startPoint = null;
                  endPoint = null;
                  startName = null;
                  destinationName = null;
                  routePoints = [];
                  context.read<DirectionsCubit>().clearDirections();
                });
              },
              onStartTap: () => _selectPlace(isStart: true),
              onDestinationTap: () => _selectPlace(isStart: false),
            ),
          ),
        ],
      ),
      floatingActionButton: MapFloatingButtons(
        isLoading: isLoading,
        onRoutePressed: () {
          setState(() {
            isRouting = true;
            endPoint = null;
            startPoint = null;
            startName = null;
            destinationName = null;
            routePoints = [];
          });
        },
        onLocationPressed: () async {
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
                backgroundColor: Colors.blue,
              ),
            );
          }
          setState(() {
            isLoading = false;
          });
        },
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
        const SnackBar(content: Text('Waiting for current location...')),
      );
    }
  }

  void _drawRouteIfPointsExist() {
    LatLng? finalStart = startPoint;
    if (finalStart == null) {
      final mapState = context.read<MapCubit>().state;
      if (mapState is MapSuccess) {
        finalStart = LatLng(
          mapState.location.latitude,
          mapState.location.longitude,
        );
      }
    }
    if (finalStart != null && endPoint != null) {
      context.read<DirectionsCubit>().fetchRouteFromOSRM(
        start: finalStart,
        end: endPoint!,
      );
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([finalStart, endPoint!]),
          padding: const EdgeInsets.all(70),
        ),
      );
    }
  }
}
