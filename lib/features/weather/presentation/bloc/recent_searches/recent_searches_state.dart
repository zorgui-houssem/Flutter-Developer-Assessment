part of 'recent_searches_bloc.dart';

class RecentSearchesState extends Equatable {
  final List<String> searches;

  const RecentSearchesState({this.searches = const []});

  RecentSearchesState copyWith({List<String>? searches}) {
    return RecentSearchesState(searches: searches ?? this.searches);
  }

  @override
  List<Object?> get props => [searches];
}
