import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/book_search_result.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  final bool isRefresh;

  const SearchLoading({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class SearchLoaded extends SearchState {
  final BookSearchResult searchResult;
  final List<Book> allBooks;

  const SearchLoaded({
    required this.searchResult,
    required this.allBooks,
  });

  @override
  List<Object> get props => [searchResult, allBooks];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}

