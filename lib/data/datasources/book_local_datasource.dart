import 'package:sqflite/sqflite.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/di/database_helper.dart';
import '../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<void> saveBook(BookModel book);
  Future<List<BookModel>> getSavedBooks();
  Future<void> removeBook(String bookId);
  Future<bool> isBookSaved(String bookId);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final DatabaseHelper databaseHelper;

  BookLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> saveBook(BookModel book) async {
    try {
      final database = await databaseHelper.database;
      final bookData = book.toDatabaseJson();
      await database.insert(
        ApiConstants.booksTable,
        bookData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving book: $e');
      print('Book data: ${book.toDatabaseJson()}');
      throw CacheException(message: 'Failed to save book: $e');
    }
  }

  @override
  Future<List<BookModel>> getSavedBooks() async {
    try {
      final database = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await database.query(
        ApiConstants.booksTable,
        orderBy: 'id DESC',
      );
      
      return maps.map((map) => BookModel.fromDatabaseJson(map)).toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to get saved books');
    }
  }

  @override
  Future<void> removeBook(String bookId) async {
    try {
      final database = await databaseHelper.database;
      await database.delete(
        ApiConstants.booksTable,
        where: 'id = ?',
        whereArgs: [bookId],
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to remove book');
    }
  }

  @override
  Future<bool> isBookSaved(String bookId) async {
    try {
      final database = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await database.query(
        ApiConstants.booksTable,
        where: 'id = ?',
        whereArgs: [bookId],
        limit: 1,
      );
      
      return maps.isNotEmpty;
    } catch (e) {
      throw const CacheException(message: 'Failed to check if book is saved');
    }
  }
}

