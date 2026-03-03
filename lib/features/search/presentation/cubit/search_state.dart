import '../../domain/entities/place_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<PlaceEntity> history;
  final bool showHistory;
  SearchInitial({this.history = const [], this.showHistory = false});
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<PlaceEntity> places;
  SearchSuccess(this.places);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchCleared extends SearchState {}
