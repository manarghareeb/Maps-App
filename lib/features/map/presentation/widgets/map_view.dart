import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final LatLng? startPoint;
  final LatLng? endPoint;
  final List<LatLng> routePoints;
  final Function(LatLng) onTap;

  const MapView({
    super.key,
    required this.mapController,
    required this.startPoint,
    required this.endPoint,
    required this.routePoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: startPoint ?? const LatLng(30.0444, 31.2357),
        initialZoom: 13,
        onTap: (_, point) => onTap(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.maps_app',
        ),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 5,
                color: Colors.blue,
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
  }
}