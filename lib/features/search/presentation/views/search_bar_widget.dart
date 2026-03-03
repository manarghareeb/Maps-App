import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:maps_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:maps_app/features/search/presentation/cubit/search_state.dart';
import 'package:maps_app/features/search/presentation/widgets/search_list_view.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key, this.onPlaceSelected});
  final Function(String placeName, double lat, double lng)? onPlaceSelected;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final Debouncer debouncer = Debouncer();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: TextField(
            controller: searchController,
            onTap: () {
              if (searchController.text.isEmpty) {
                context.read<SearchCubit>().loadHistory();
              }
            },
            onChanged: (query) {
              const duration = Duration(milliseconds: 500);
              debouncer.debounce(duration: duration, onDebounce: () {
                context.read<SearchCubit>().searchPlaces(query);
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search for a location',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 5),
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is SearchSuccess && state.places.isNotEmpty) {
              return SearchListView(
                places: state.places,
                icon: Icons.location_on,
                onTap: (place) {
                  final double lat = place.lat;
                  final double lon = place.lng;
                  context.read<SearchCubit>().addToHistory(place);
                  context.read<SearchCubit>().clearSearch();
                  searchController.clear();
                  FocusScope.of(context).unfocus();
                  widget.onPlaceSelected?.call(place.name, lat, lon);
                },
              );
            } else if (state is SearchInitial &&
                state.showHistory &&
                state.history.isNotEmpty) {
              return SearchListView(
                places: state.history,
                icon: Icons.history,
                onTap: (place) {
                  final double lat = place.lat;
                  final double lon = place.lng;
                  context.read<SearchCubit>().addToHistory(place);
                  context.read<SearchCubit>().clearSearch();
                  searchController.clear();
                  FocusScope.of(context).unfocus();
                  widget.onPlaceSelected?.call(place.name, lat, lon);
                },
                onDelete: (place) {
                  context.read<SearchCubit>().removeFromHistory(place);
                },
              );
            } else if (state is SearchError) {
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is SearchCleared) {
              return const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
