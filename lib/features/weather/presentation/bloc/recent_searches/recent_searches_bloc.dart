import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/clear_recent_searches_usecase.dart';
import '../../../domain/usecases/get_recent_searches_usecase.dart';
import '../../../domain/usecases/remove_recent_search_usecase.dart';
import '../../../domain/usecases/save_recent_search_usecase.dart';

part 'recent_searches_event.dart';
part 'recent_searches_state.dart';

@injectable
class RecentSearchesBloc
    extends Bloc<RecentSearchesEvent, RecentSearchesState> {
  final GetRecentSearchesUseCase _getRecentSearches;
  final SaveRecentSearchUseCase _saveRecentSearch;
  final RemoveRecentSearchUseCase _removeRecentSearch;
  final ClearRecentSearchesUseCase _clearRecentSearches;

  RecentSearchesBloc({
    required GetRecentSearchesUseCase getRecentSearches,
    required SaveRecentSearchUseCase saveRecentSearch,
    required RemoveRecentSearchUseCase removeRecentSearch,
    required ClearRecentSearchesUseCase clearRecentSearches,
  })  : _getRecentSearches = getRecentSearches,
        _saveRecentSearch = saveRecentSearch,
        _removeRecentSearch = removeRecentSearch,
        _clearRecentSearches = clearRecentSearches,
        super(const RecentSearchesState()) {
    on<RecentSearchesStarted>(_onStarted);
    on<RecentSearchAdded>(_onAdded);
    on<RecentSearchRemoved>(_onRemoved);
    on<RecentSearchesCleared>(_onCleared);
    add(const RecentSearchesStarted());
  }

  Future<void> _onStarted(
    RecentSearchesStarted event,
    Emitter<RecentSearchesState> emit,
  ) async {
    final searches = await _getRecentSearches();
    emit(state.copyWith(searches: searches));
  }

  Future<void> _onAdded(
    RecentSearchAdded event,
    Emitter<RecentSearchesState> emit,
  ) async {
    await _saveRecentSearch(event.city);
    final searches = await _getRecentSearches();
    emit(state.copyWith(searches: searches));
  }

  Future<void> _onRemoved(
    RecentSearchRemoved event,
    Emitter<RecentSearchesState> emit,
  ) async {
    await _removeRecentSearch(event.city);
    final searches = await _getRecentSearches();
    emit(state.copyWith(searches: searches));
  }

  Future<void> _onCleared(
    RecentSearchesCleared event,
    Emitter<RecentSearchesState> emit,
  ) async {
    await _clearRecentSearches();
    emit(const RecentSearchesState());
  }
}
