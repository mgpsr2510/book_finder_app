import 'package:dartz/dartz.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';

class GetSavedBooks {
  final BookRepository repository;

  GetSavedBooks(this.repository);

  Future<Either<Failure, List<Book>>> call() async {
    return await repository.getSavedBooks();
  }
}

