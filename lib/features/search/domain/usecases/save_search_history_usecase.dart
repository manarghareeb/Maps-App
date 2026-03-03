import 'package:maps_app/features/search/domain/entities/place_entity.dart';
import 'package:maps_app/features/search/domain/repository/search_repository.dart';

class SaveSearchHistoryUsecase {
  final SearchRepository repository;

  SaveSearchHistoryUsecase({required this.repository});

  Future<void> call(List<PlaceEntity> history) async {
    return await repository.saveSearchHistory(history);
  }
}