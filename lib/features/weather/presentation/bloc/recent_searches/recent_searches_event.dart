part of 'recent_searches_bloc.dart';

abstract class RecentSearchesEvent extends Equatable {
  const RecentSearchesEvent();

  @override
  List<Object?> get props => [];
}

class RecentSearchesStarted extends RecentSearchesEvent {
  const RecentSearchesStarted();
}

class RecentSearchAdded extends RecentSearchesEvent {
  final String city;

  const RecentSearchAdded(this.city);

  @override
  List<Object?> get props => [city];
}

class RecentSearchRemoved extends RecentSearchesEvent {
  final String city;

  const RecentSearchRemoved(this.city);

  @override
  List<Object?> get props => [city];
}

class RecentSearchesCleared extends RecentSearchesEvent {
  const RecentSearchesCleared();
}
