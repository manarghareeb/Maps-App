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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchCubit>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
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
                    debouncer.debounce(
                      duration: duration,
                      onDebounce: () {
                        context.read<SearchCubit>().searchPlaces(query);
                      },
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a location',
                    border: InputBorder.none,
                    icon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchSuccess &&
                        state.places.isNotEmpty) {
                      return SearchListView(
                        places: state.places,
                        icon: Icons.location_on,
                        onTap: (place) {
                          _handleSelection(place);
                        },
                      );
                    } else if (state is SearchInitial &&
                        state.showHistory &&
                        state.history.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Text(
                              "Recent Searches",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SearchListView(
                              places: state.history,
                              icon: Icons.history,
                              onTap: (place) => _handleSelection(place),
                              onDelete: (place) {
                                context.read<SearchCubit>().removeFromHistory(
                                  place,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSelection(dynamic place) {
    context.read<SearchCubit>().addToHistory(place);
    /*context.read<SearchCubit>().clearSearch();
    searchController.clear();
    FocusScope.of(context).unfocus();*/
    Navigator.pop(context, {
      'name': place.name,
      'lat': place.lat,
      'lng': place.lng,
    });
  }
}
