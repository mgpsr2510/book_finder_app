import 'package:dartz/dartz.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';

class GetBookDetails {
  final BookRepository repository;

  GetBookDetails(this.repository);

  Future<Either<Failure, Book>> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Book ID cannot be empty'));
    }
    
    return await repository.getBookDetails(bookId.trim());
  }
}

