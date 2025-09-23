import '../../domain/entities/book_search_result.dart';
import '../../domain/entities/book.dart';
import 'book_model.dart';

class BookSearchResultModel extends BookSearchResult {
  const BookSearchResultModel({
    required super.books,
    required super.totalCount,
    required super.currentPage,
    required super.hasNextPage,
  });

  factory BookSearchResultModel.fromOpenLibraryJson(Map<String, dynamic> json) {
    final docs = json['docs'] as List<dynamic>? ?? [];
    final books = docs
        .map((doc) => BookModel.fromOpenLibraryJson({'work': doc}))
        .toList();
    
    final totalCount = json['numFound'] ?? 0;
    final currentPage = ((json['start'] ?? 0) / (json['numFound'] ?? 1)).ceil();
    final hasNextPage = (json['start'] ?? 0) + books.length < totalCount;
    
    return BookSearchResultModel(
      books: books,
      totalCount: totalCount,
      currentPage: currentPage,
      hasNextPage: hasNextPage,
    );
  }
}