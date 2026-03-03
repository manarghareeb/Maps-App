import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_app/core/api/api_consumer.dart';
import 'package:maps_app/features/map/data/models/direction_model.dart';

abstract class MapRemoteDataSource {
  Future<DirectionModel> getDirections(LatLng start, LatLng end);
  Future<List<LatLng>> fetchRouteFromOSRM(LatLng origin, LatLng destination);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final ApiConsumer apiConsumer;
  final Dio dio;
  MapRemoteDataSourceImpl({required this.apiConsumer, required this.dio});

  @override
  Future<DirectionModel> getDirections(LatLng start, LatLng end) async {
    final response = await apiConsumer.get(
      "https://api.openrouteservice.org/v2/directions/driving-car",
      queryParameters: {
        'api_key':
            'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjM3YWQ5YzExMjQ3ZjQwZmM4OTZlZWVhNWUwNjRiODA1IiwiaCI6Im11cm11cjY0In0=',
        'start': '${start.longitude},${start.latitude}',
        'end': '${end.longitude},${end.latitude}',
      },
    );
    return DirectionModel.fromJson(response);
  }

  @override
  Future<List<LatLng>> fetchRouteFromOSRM(
    LatLng origin,
    LatLng destination,
  ) async {
    final pathParams =
        "${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}";
    final osrmUrl =
        "https://router.project-osrm.org/route/v1/driving/$pathParams?overview=full&geometries=geojson";

    final response = await dio.get(osrmUrl);

    if (response.statusCode != 200) return [];

    final coords =
        response.data['routes'][0]['geometry']['coordinates'] as List;
    return coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();
  }
}
