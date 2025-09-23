import '../../core/error/exceptions.dart';
import '../../core/di/web_database_helper.dart';
import '../models/book_model.dart';
import '../../domain/entities/book.dart';

abstract class BookWebLocalDataSource {
  Future<void> saveBook(Book book);
  Future<List<Book>> getSavedBooks();
  Future<void> removeBook(String bookId);
  Future<bool> isBookSaved(String bookId);
}

class BookWebLocalDataSourceImpl implements BookWebLocalDataSource {
  final WebDatabaseHelper webDatabaseHelper;

  BookWebLocalDataSourceImpl(this.webDatabaseHelper);

  @override
  Future<void> saveBook(Book book) async {
    try {
      await webDatabaseHelper.saveBook(book);
    } catch (e) {
      throw const CacheException(message: 'Failed to save book');
    }
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    try {
      return await webDatabaseHelper.getSavedBooks();
    } catch (e) {
      throw const CacheException(message: 'Failed to get saved books');
    }
  }

  @override
  Future<void> removeBook(String bookId) async {
    try {
      await webDatabaseHelper.removeBook(bookId);
    } catch (e) {
      throw const CacheException(message: 'Failed to remove book');
    }
  }

  @override
  Future<bool> isBookSaved(String bookId) async {
    try {
      return await webDatabaseHelper.isBookSaved(bookId);
    } catch (e) {
      throw const CacheException(message: 'Failed to check if book is saved');
    }
  }
}
