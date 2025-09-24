import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder_app/data/models/book_search_result_model.dart';
import 'package:book_finder_app/data/models/book_model.dart';
import 'package:book_finder_app/domain/entities/book_search_result.dart';

void main() {
  group('BookSearchResultModel', () {
    final List<BookModel> tBooks = [
      const BookModel(
        id: '1',
        title: 'Flutter in Action',
        authors: ['Eric Windmill'],
        coverImageUrl: 'https://example.com/cover1.jpg',
        publishDate: '2019',
      ),
      const BookModel(
        id: '2',
        title: 'Flutter Complete Reference',
        authors: ['Alberto Miola'],
        coverImageUrl: 'https://example.com/cover2.jpg',
        publishDate: '2020',
      ),
    ];

    group('fromOpenLibraryJson', () {
      test('should create BookSearchResultModel from Open Library JSON', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
              'cover_i': 123456,
              'first_publish_year': 2019,
            },
            {
              'key': '/works/OL789012W',
              'title': 'Flutter Complete Reference',
              'author_name': ['Alberto Miola'],
              'cover_i': 789012,
              'first_publish_year': 2020,
            },
          ],
          'numFound': 100,
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.books, hasLength(2));
        expect(result.books[0].id, 'OL123456W');
        expect(result.books[0].title, 'Flutter in Action');
        expect(result.books[1].id, 'OL789012W');
        expect(result.books[1].title, 'Flutter Complete Reference');
        expect(result.totalCount, 100);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, true);
      });

      test('should handle empty docs array', () {
        // arrange
        final json = {
          'docs': [],
          'numFound': 0,
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.books, isEmpty);
        expect(result.totalCount, 0);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, false);
      });

      test('should handle missing docs field', () {
        // arrange
        final json = {
          'numFound': 100,
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.books, isEmpty);
        expect(result.totalCount, 100);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, true);
      });

      test('should calculate currentPage correctly', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
            },
          ],
          'numFound': 100,
          'start': 20, // Start at 20, so page 3 (assuming 10 per page)
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.currentPage, 3);
      });

      test('should calculate hasNextPage correctly when there are more results', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
            },
          ],
          'numFound': 100,
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.hasNextPage, true); // 0 + 1 < 100
      });

      test('should calculate hasNextPage correctly when there are no more results', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
            },
          ],
          'numFound': 1,
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.hasNextPage, false); // 0 + 1 >= 1
      });

      test('should handle missing numFound field', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
            },
          ],
          'start': 0,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.totalCount, 0);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, true);
      });

      test('should handle missing start field', () {
        // arrange
        final json = {
          'docs': [
            {
              'key': '/works/OL123456W',
              'title': 'Flutter in Action',
              'author_name': ['Eric Windmill'],
            },
          ],
          'numFound': 100,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.totalCount, 100);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, true);
      });

      test('should handle null values gracefully', () {
        // arrange
        final json = {
          'docs': null,
          'numFound': null,
          'start': null,
        };

        // act
        final result = BookSearchResultModel.fromOpenLibraryJson(json);

        // assert
        expect(result.books, isEmpty);
        expect(result.totalCount, 0);
        expect(result.currentPage, 1);
        expect(result.hasNextPage, true);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final result1 = BookSearchResultModel(
          books: tBooks,
          totalCount: 100,
          currentPage: 1,
          hasNextPage: true,
        );
        final result2 = BookSearchResultModel(
          books: tBooks,
          totalCount: 100,
          currentPage: 1,
          hasNextPage: true,
        );

        // assert
        expect(result1, equals(result2));
      });

      test('should not be equal when properties are different', () {
        // arrange
        final result1 = BookSearchResultModel(
          books: tBooks,
          totalCount: 100,
          currentPage: 1,
          hasNextPage: true,
        );
        final result2 = BookSearchResultModel(
          books: tBooks,
          totalCount: 200, // Different total count
          currentPage: 1,
          hasNextPage: true,
        );

        // assert
        expect(result1, isNot(equals(result2)));
      });
    });

    group('inheritance', () {
      test('should be instance of BookSearchResult', () {
        // arrange
        final result = BookSearchResultModel(
          books: tBooks,
          totalCount: 100,
          currentPage: 1,
          hasNextPage: true,
        );

        // assert
        expect(result, isA<BookSearchResult>());
      });
    });
  });
}
