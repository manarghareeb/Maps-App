import 'package:maps_app/core/api/end_ponits.dart';
import 'package:maps_app/features/search/data/models/place_model.dart';
import '../../../../core/api/api_consumer.dart';

abstract class SearchRemoteDataSource {
  Future<List<PlaceModel>> searchPlaces(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiConsumer apiConsumer;

  SearchRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final response = await apiConsumer.get(
      EndPoints.search,
      queryParameters: {
        'q': query,
        'format': 'json',
        'limit': 10,
        'addressdetails': 1,
      },
    );
    return (response as List).map((e) => PlaceModel.fromJson(e)).toList();
  }
}