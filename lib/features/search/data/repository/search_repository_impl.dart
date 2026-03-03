import 'package:dartz/dartz.dart';
import 'package:maps_app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:maps_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:maps_app/features/search/domain/repository/search_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/place_entity.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  SearchRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    try {
      final places = await remoteDataSource.searchPlaces(query);
      return Right(places);
    } catch (e) {
      return Left(ServerFailure("Failed to load search results"));
    }
  }

  @override
  List<PlaceEntity> getSearchHistory() {
    return localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchHistory(List<PlaceEntity> history) async {
    return await localDataSource.cacheSearchHistory(history);
  }

  @override
  Future<void> removeFromSearchHistory(PlaceEntity place) async {
    return await localDataSource.removeFromSearchHistory(place);
  }
}