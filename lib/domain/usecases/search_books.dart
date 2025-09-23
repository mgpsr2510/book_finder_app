import 'package:dartz/dartz.dart';
import '../entities/book_search_result.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';

class SearchBooks {
  final BookRepository repository;

  SearchBooks(this.repository);

  Future<Either<Failure, BookSearchResult>> call({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Search query cannot be empty'));
    }
    
    return await repository.searchBooks(
      query: query.trim(),
      page: page,
      limit: limit,
    );
  }
}

