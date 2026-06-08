import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/city_suggestion.dart';
import '../../../domain/usecases/search_cities_usecase.dart';

part 'city_search_event.dart';
part 'city_search_state.dart';

@injectable
class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final SearchCitiesUseCase _searchCities;
  Timer? _debounceTimer;

  CitySearchBloc({required SearchCitiesUseCase searchCities})
      : _searchCities = searchCities,
        super(const CitySearchInitial()) {
    on<CitySearchQueryChanged>(_onQueryChanged);
    on<CitySearchCleared>(_onCleared);
  }

  void _onQueryChanged(
    CitySearchQueryChanged event,
    Emitter<CitySearchState> emit,
  ) {
    _debounceTimer?.cancel();
    final query = event.query.trim();

    if (query.length < 2) {
      emit(const CitySearchInitial());
      return;
    }

    emit(const CitySearchLoading());

    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      try {
        final results = await _searchCities(
          SearchCitiesParams(query: query, limit: 5),
        );
        if (!isClosed) {
          if (results.isEmpty) {
            emit(CitySearchEmpty(query: query));
          } else {
            emit(CitySearchLoaded(suggestions: results, query: query));
          }
        }
      } catch (_) {
        if (!isClosed) emit(const CitySearchError());
      }
    });
  }

  void _onCleared(CitySearchCleared event, Emitter<CitySearchState> emit) {
    _debounceTimer?.cancel();
    emit(const CitySearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
