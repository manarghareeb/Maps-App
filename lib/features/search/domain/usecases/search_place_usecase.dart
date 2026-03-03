import 'package:dartz/dartz.dart';
import 'package:maps_app/core/errors/failures.dart';
import 'package:maps_app/features/search/domain/entities/place_entity.dart';
import 'package:maps_app/features/search/domain/repository/search_repository.dart';

class SearchPlacesUseCase {
  final SearchRepository repository; 
  SearchPlacesUseCase({required this.repository});

  Future<Either<Failure, List<PlaceEntity>>> call(String query) async {
    return await repository.searchPlaces(query);
  }
}