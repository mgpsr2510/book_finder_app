import 'package:equatable/equatable.dart';
import 'book.dart';

class BookSearchResult extends Equatable {
  final List<Book> books;
  final int totalCount;
  final int currentPage;
  final bool hasNextPage;

  const BookSearchResult({
    required this.books,
    required this.totalCount,
    required this.currentPage,
    required this.hasNextPage,
  });

  @override
  List<Object> get props => [books, totalCount, currentPage, hasNextPage];
}

