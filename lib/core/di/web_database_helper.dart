import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/book.dart';
import '../constants/api_constants.dart';

class WebDatabaseHelper {
  static const String _booksKey = 'saved_books';

  // For web, we'll use SharedPreferences as a simple storage solution
  // In a production app, you might want to use IndexedDB or another web-compatible storage
  
  Future<void> saveBook(Book book) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = await getSavedBooks();
      
      // Check if book already exists
      final existingIndex = savedBooks.indexWhere((b) => b.id == book.id);
      if (existingIndex != -1) {
        savedBooks[existingIndex] = book;
      } else {
        savedBooks.add(book);
      }
      
      final booksJson = savedBooks.map((book) => _bookToJson(book)).toList();
      await prefs.setString(_booksKey, jsonEncode(booksJson));
    } catch (e) {
      throw Exception('Failed to save book: $e');
    }
  }

  Future<List<Book>> getSavedBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getString(_booksKey);
      
      if (booksJson == null) return [];
      
      final List<dynamic> booksList = jsonDecode(booksJson);
      return booksList.map((json) => _bookFromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get saved books: $e');
    }
  }

  Future<void> removeBook(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = await getSavedBooks();
      
      savedBooks.removeWhere((book) => book.id == bookId);
      
      final booksJson = savedBooks.map((book) => _bookToJson(book)).toList();
      await prefs.setString(_booksKey, jsonEncode(booksJson));
    } catch (e) {
      throw Exception('Failed to remove book: $e');
    }
  }

  Future<bool> isBookSaved(String bookId) async {
    try {
      final savedBooks = await getSavedBooks();
      return savedBooks.any((book) => book.id == bookId);
    } catch (e) {
      throw Exception('Failed to check if book is saved: $e');
    }
  }

  Map<String, dynamic> _bookToJson(Book book) {
    return {
      'id': book.id,
      'title': book.title,
      'authors': book.authors,
      'coverImageUrl': book.coverImageUrl,
      'description': book.description,
      'publishDate': book.publishDate,
      'subjects': book.subjects,
      'pageCount': book.pageCount,
      'isbn': book.isbn,
      'language': book.language,
      'publisher': book.publisher,
    };
  }

  Book _bookFromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      coverImageUrl: json['coverImageUrl'],
      description: json['description'],
      publishDate: json['publishDate'],
      subjects: json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      pageCount: json['pageCount'],
      isbn: json['isbn'],
      language: json['language'],
      publisher: json['publisher'],
    );
  }
}
