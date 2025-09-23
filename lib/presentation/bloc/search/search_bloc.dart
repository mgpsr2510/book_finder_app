import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_books.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooks searchBooks;

  SearchBloc(this.searchBooks) : super(const SearchInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.isRefresh) {
      emit(const SearchLoading(isRefresh: true));
    } else {
      emit(const SearchLoading());
    }

    final result = await searchBooks(
      query: event.query,
      page: event.page,
      limit: event.limit,
    );

    // Check if emitter is still active before emitting
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(SearchError(message: failure.message)),
        (searchResult) => emit(SearchLoaded(
          searchResult: searchResult,
          allBooks: searchResult.books,
        )),
      );
    }
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooksEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      final nextPage = currentState.searchResult.currentPage + 1;

      if (currentState.searchResult.hasNextPage) {
        final result = await searchBooks(
          query: currentState.searchResult.books.isNotEmpty 
              ? currentState.searchResult.books.first.title 
              : '',
          page: nextPage,
          limit: event.limit,
        );

        // Check if emitter is still active before emitting
        if (!emit.isDone) {
          result.fold(
            (failure) => emit(SearchError(message: failure.message)),
            (searchResult) => emit(SearchLoaded(
              searchResult: searchResult,
              allBooks: [...currentState.allBooks, ...searchResult.books],
            )),
          );
        }
      }
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchInitial());
  }
}

