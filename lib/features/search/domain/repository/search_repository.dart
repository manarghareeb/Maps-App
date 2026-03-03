import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/place_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query);
  Future<void> saveSearchHistory(List<PlaceEntity> history);
  List<PlaceEntity> getSearchHistory();
  Future<void> removeFromSearchHistory(PlaceEntity place);
}