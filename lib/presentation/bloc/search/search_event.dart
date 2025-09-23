import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchBooksEvent extends SearchEvent {
  final String query;
  final int page;
  final int limit;
  final bool isRefresh;

  const SearchBooksEvent({
    required this.query,
    this.page = 1,
    this.limit = 10, // Default to 10 books for initial load
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [query, page, limit, isRefresh];
}

class LoadMoreBooksEvent extends SearchEvent {
  final int limit;
  
  const LoadMoreBooksEvent({this.limit = 10}); // Default to 10 for load more
  
  @override
  List<Object> get props => [limit];
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}

