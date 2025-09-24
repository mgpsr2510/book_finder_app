import 'package:flutter_test/flutter_test.dart';

/// Test configuration and utilities for Book Finder App tests
class TestConfig {
  /// Common test data for books
  static const testBookId = '1';
  static const testBookTitle = 'Flutter in Action';
  static const testBookAuthor = 'Eric Windmill';
  static const testBookCoverUrl = 'https://example.com/cover1.jpg';
  static const testBookPublishDate = '2019';
  static const testSearchQuery = 'flutter';
  static const testPage = 1;
  static const testLimit = 10;

  /// Common test book data
  static const testBookData = {
    'id': testBookId,
    'title': testBookTitle,
    'authors': [testBookAuthor],
    'coverImageUrl': testBookCoverUrl,
    'publishDate': testBookPublishDate,
  };

  /// Common Open Library API response structure
  static const testOpenLibraryResponse = {
    'docs': [
      {
        'key': '/works/OL123456W',
        'title': testBookTitle,
        'author_name': [testBookAuthor],
        'cover_i': 123456,
        'first_publish_year': 2019,
      }
    ],
    'numFound': 100,
    'start': 0,
  };

  /// Setup function for tests that need common configuration
  static void setup() {
    // Add any common test setup here
    TestWidgetsFlutterBinding.ensureInitialized();
  }
}
