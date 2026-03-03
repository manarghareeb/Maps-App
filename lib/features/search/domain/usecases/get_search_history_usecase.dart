import 'package:maps_app/features/search/domain/entities/place_entity.dart';
import 'package:maps_app/features/search/domain/repository/search_repository.dart';

class GetSearchHistoryUsecase {
  final SearchRepository repository;
  GetSearchHistoryUsecase({required this.repository});

  List<PlaceEntity> call() {
    return repository.getSearchHistory();
  }
}