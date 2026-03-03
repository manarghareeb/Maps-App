import '../entities/place_entity.dart';
import '../repository/search_repository.dart';

class RemoveFromSearchHistoryUsecase {
  final SearchRepository repository;

  RemoveFromSearchHistoryUsecase({required this.repository});

  Future<void> call(PlaceEntity place) async {
    return await repository.removeFromSearchHistory(place);
  }
}