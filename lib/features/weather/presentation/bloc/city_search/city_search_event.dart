part of 'city_search_bloc.dart';

abstract class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object?> get props => [];
}

class CitySearchQueryChanged extends CitySearchEvent {
  final String query;

  const CitySearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CitySearchCleared extends CitySearchEvent {
  const CitySearchCleared();
}
