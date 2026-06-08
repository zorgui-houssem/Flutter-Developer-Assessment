part of 'city_search_bloc.dart';

abstract class CitySearchState extends Equatable {
  const CitySearchState();

  @override
  List<Object?> get props => [];
}

class CitySearchInitial extends CitySearchState {
  const CitySearchInitial();
}

class CitySearchLoading extends CitySearchState {
  const CitySearchLoading();
}

class CitySearchLoaded extends CitySearchState {
  final List<CitySuggestion> suggestions;
  final String query;

  const CitySearchLoaded({required this.suggestions, required this.query});

  @override
  List<Object?> get props => [suggestions, query];
}

class CitySearchEmpty extends CitySearchState {
  final String query;

  const CitySearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

class CitySearchError extends CitySearchState {
  const CitySearchError();
}
