import 'package:dartz/dartz.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';

class SaveBook {
  final BookRepository repository;

  SaveBook(this.repository);

  Future<Either<Failure, void>> call(Book book) async {
    return await repository.saveBook(book);
  }
}

