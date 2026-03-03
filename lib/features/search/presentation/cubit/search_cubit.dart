import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/features/search/domain/entities/place_entity.dart';
import 'package:maps_app/features/search/domain/usecases/get_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/remove_from_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/save_search_history_usecase.dart';
import 'package:maps_app/features/search/domain/usecases/search_place_usecase.dart';
import 'package:maps_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchPlacesUseCase searchUseCase;
  final GetSearchHistoryUsecase getHistoryUseCase;
  final SaveSearchHistoryUsecase saveHistoryUseCase;
  final RemoveFromSearchHistoryUsecase removeHistoryUseCase;
  SearchCubit({
    required this.searchUseCase,
    required this.getHistoryUseCase,
    required this.saveHistoryUseCase,
    required this.removeHistoryUseCase,
  }) : super(SearchInitial());

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      loadHistory();
      return;
    }
    emit(SearchLoading());
    final result = await searchUseCase(query);
    result.fold(
      (failure) {
        log('Error searching places: ${failure.message}');
        emit(SearchError(failure.message));
      },
      (places) {
        log('Places found: ${places.length}');
        emit(SearchSuccess(places));
      },
    );
  }

  void clearSearch() {
    emit(SearchInitial(history: [], showHistory: false));
  }

  void loadHistory() {
    final history = getHistoryUseCase();
    log('Loaded search history: ${history.length} items');
    emit(SearchInitial(history: history, showHistory: true));
  }

  void addToHistory(PlaceEntity place) async {
    final currentHistory = getHistoryUseCase();

    currentHistory.removeWhere((item) => item.name == place.name);
    currentHistory.insert(0, place);

    if (currentHistory.length > 5) {
      currentHistory.removeLast();
    }

    await saveHistoryUseCase(currentHistory);
    emit(SearchInitial(history: currentHistory));
  }

  Future<void> removeFromHistory(PlaceEntity place) async {
    await removeHistoryUseCase(place);
    final updatedHistory = getHistoryUseCase();
    emit(SearchInitial(history: updatedHistory));
  }
}
