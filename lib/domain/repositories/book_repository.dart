import 'package:dartz/dartz.dart';
import '../entities/book.dart';
import '../entities/book_search_result.dart';
import '../../core/error/failures.dart';

abstract class BookRepository {
  Future<Either<Failure, BookSearchResult>> searchBooks({
    required String query,
    int page = 1,
    int limit = 10,
  });
  
  Future<Either<Failure, Book>> getBookDetails(String bookId);
  
  Future<Either<Failure, void>> saveBook(Book book);
  
  Future<Either<Failure, List<Book>>> getSavedBooks();
  
  Future<Either<Failure, void>> removeBook(String bookId);
}

