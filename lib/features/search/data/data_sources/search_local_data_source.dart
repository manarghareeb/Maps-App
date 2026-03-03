import 'package:maps_app/core/cache/cache_helper.dart';
import 'package:maps_app/features/search/domain/entities/place_entity.dart';

abstract class SearchLocalDataSource {
  Future<void> cacheSearchHistory(List<PlaceEntity> history);
  List<PlaceEntity> getSearchHistory();
  Future<void> removeFromSearchHistory(PlaceEntity place);
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final CacheHelper cacheHelper;
  SearchLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<void> cacheSearchHistory(List<PlaceEntity> history) async {
    List<String> historyJson = history.map((e) => e.toJson()).toList();
    await cacheHelper.saveData(key: 'search_history', value: historyJson);
  }

  @override
  List<PlaceEntity> getSearchHistory() {
    final List<dynamic>? data = cacheHelper.getData(key: 'search_history');
    if (data != null) {
      return data.map((e) => PlaceEntity.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> removeFromSearchHistory(PlaceEntity place) async {
    final current = getSearchHistory();
    current.removeWhere((p) => p.name == place.name);
    await cacheHelper.saveData(
      key: 'search_history',
      value: current.map((e) => e.toJson()).toList(),
    );
  }
}