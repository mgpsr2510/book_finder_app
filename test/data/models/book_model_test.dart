import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder_app/data/models/book_model.dart';
import 'package:book_finder_app/domain/entities/book.dart';

void main() {
  group('BookModel', () {
    const tBookModel = BookModel(
      id: '1',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      coverImageUrl: 'https://example.com/cover1.jpg',
      description: 'A comprehensive guide to Flutter development',
      publishDate: '2019',
      subjects: ['Programming', 'Mobile Development'],
      pageCount: 300,
      isbn: '9781617295997',
      language: 'en',
      publisher: 'Manning Publications',
    );

    group('fromBook', () {
      test('should create BookModel from Book entity', () {
        // arrange
        const book = Book(
          id: '1',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
          coverImageUrl: 'https://example.com/cover1.jpg',
          description: 'A comprehensive guide to Flutter development',
          publishDate: '2019',
          subjects: ['Programming', 'Mobile Development'],
          pageCount: 300,
          isbn: '9781617295997',
          language: 'en',
          publisher: 'Manning Publications',
        );

        // act
        final result = BookModel.fromBook(book);

        // assert
        expect(result, tBookModel);
      });
    });

    group('fromOpenLibraryJson', () {
      test('should create BookModel from Open Library search JSON', () {
        // arrange
        final json = {
          'work': {
            'key': '/works/OL123456W',
            'title': 'Flutter in Action',
            'author_name': ['Eric Windmill'],
            'cover_i': 123456,
            'first_publish_year': 2019,
            'subject': ['Programming', 'Mobile Development'],
          }
        };

        // act
        final result = BookModel.fromOpenLibraryJson(json);

        // assert
        expect(result.id, 'OL123456W');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, ['Eric Windmill']);
        expect(result.coverImageUrl, 'https://covers.openlibrary.org/b/id/123456-M.jpg');
        expect(result.publishDate, '2019');
        expect(result.subjects, ['Programming', 'Mobile Development']);
      });

      test('should handle single author name', () {
        // arrange
        final json = {
          'work': {
            'key': '/works/OL123456W',
            'title': 'Flutter in Action',
            'author_name': 'Eric Windmill', // Single string instead of list
            'cover_i': 123456,
            'first_publish_year': 2019,
          }
        };

        // act
        final result = BookModel.fromOpenLibraryJson(json);

        // assert
        expect(result.authors, ['Eric Windmill']);
      });

      test('should handle missing optional fields', () {
        // arrange
        final json = {
          'work': {
            'key': '/works/OL123456W',
            'title': 'Flutter in Action',
            'author_name': ['Eric Windmill'],
            // Missing cover_i, first_publish_year, subject
          }
        };

        // act
        final result = BookModel.fromOpenLibraryJson(json);

        // assert
        expect(result.id, 'OL123456W');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, ['Eric Windmill']);
        expect(result.coverImageUrl, isNull);
        expect(result.publishDate, isNull);
        expect(result.subjects, isNull);
      });

      test('should handle missing key field', () {
        // arrange
        final json = {
          'work': {
            'title': 'Flutter in Action',
            'author_name': ['Eric Windmill'],
          }
        };

        // act
        final result = BookModel.fromOpenLibraryJson(json);

        // assert
        expect(result.id, '');
        expect(result.title, 'Flutter in Action');
      });

      test('should handle missing title field', () {
        // arrange
        final json = {
          'work': {
            'key': '/works/OL123456W',
            'author_name': ['Eric Windmill'],
          }
        };

        // act
        final result = BookModel.fromOpenLibraryJson(json);

        // assert
        expect(result.id, 'OL123456W');
        expect(result.title, 'Unknown Title');
      });
    });

    group('fromOpenLibraryWorkJson', () {
      test('should create BookModel from Open Library work JSON', () {
        // arrange
        final json = {
          'key': '/works/OL123456W',
          'title': 'Flutter in Action',
          'authors': [
            {
              'author': {
                'key': '/authors/OL123456A',
              }
            }
          ],
          'covers': [123456],
          'description': {
            'value': 'A comprehensive guide to Flutter development'
          },
          'first_publish_date': '2019-01-01',
          'subjects': ['Programming', 'Mobile Development'],
          'number_of_pages_median': 300,
          'isbn_13': ['9781617295997'],
          'languages': [
            {
              'key': '/languages/eng'
            }
          ],
          'publishers': [
            {
              'name': 'Manning Publications'
            }
          ],
        };

        // act
        final result = BookModel.fromOpenLibraryWorkJson(json);

        // assert
        expect(result.id, 'OL123456W');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, ['OL123456A']);
        expect(result.coverImageUrl, 'https://covers.openlibrary.org/b/id/123456-M.jpg');
        expect(result.description, 'A comprehensive guide to Flutter development');
        expect(result.publishDate, '2019-01-01');
        expect(result.subjects, ['Programming', 'Mobile Development']);
        expect(result.pageCount, 300);
        expect(result.isbn, '9781617295997');
        expect(result.language, 'eng');
        expect(result.publisher, 'Manning Publications');
      });

      test('should handle string description', () {
        // arrange
        final json = {
          'key': '/works/OL123456W',
          'title': 'Flutter in Action',
          'authors': [],
          'description': 'A comprehensive guide to Flutter development', // String instead of object
        };

        // act
        final result = BookModel.fromOpenLibraryWorkJson(json);

        // assert
        expect(result.description, 'A comprehensive guide to Flutter development');
      });

      test('should handle ISBN_10 when ISBN_13 is not available', () {
        // arrange
        final json = {
          'key': '/works/OL123456W',
          'title': 'Flutter in Action',
          'authors': [],
          'isbn_10': ['1617295997'],
        };

        // act
        final result = BookModel.fromOpenLibraryWorkJson(json);

        // assert
        expect(result.isbn, '1617295997');
      });

      test('should handle direct author key structure', () {
        // arrange
        final json = {
          'key': '/works/OL123456W',
          'title': 'Flutter in Action',
          'authors': [
            {
              'key': '/authors/OL123456A', // Direct key instead of nested author
            }
          ],
        };

        // act
        final result = BookModel.fromOpenLibraryWorkJson(json);

        // assert
        expect(result.authors, ['OL123456A']);
      });

      test('should handle parsing errors gracefully', () {
        // arrange
        final json = {
          'key': '/works/OL123456W',
          'title': 'Flutter in Action',
          'authors': 'invalid', // Invalid structure
        };

        // act
        final result = BookModel.fromOpenLibraryWorkJson(json);

        // assert
        expect(result.id, 'OL123456W');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, []);
      });
    });

    group('toDatabaseJson', () {
      test('should convert BookModel to database JSON', () {
        // act
        final result = tBookModel.toDatabaseJson();

        // assert
        expect(result['id'], '1');
        expect(result['title'], 'Flutter in Action');
        expect(result['authors'], 'Eric Windmill');
        expect(result['cover_image_url'], 'https://example.com/cover1.jpg');
        expect(result['description'], 'A comprehensive guide to Flutter development');
        expect(result['publish_date'], '2019');
        expect(result['subjects'], 'Programming,Mobile Development');
        expect(result['page_count'], 300);
        expect(result['isbn'], '9781617295997');
        expect(result['language'], 'en');
        expect(result['publisher'], 'Manning Publications');
        expect(result['created_at'], isA<int>());
      });

      test('should handle null values in database JSON', () {
        // arrange
        const bookModel = BookModel(
          id: '1',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
        );

        // act
        final result = bookModel.toDatabaseJson();

        // assert
        expect(result['id'], '1');
        expect(result['title'], 'Flutter in Action');
        expect(result['authors'], 'Eric Windmill');
        expect(result['cover_image_url'], isNull);
        expect(result['description'], isNull);
        expect(result['publish_date'], isNull);
        expect(result['subjects'], isNull);
        expect(result['page_count'], isNull);
        expect(result['isbn'], isNull);
        expect(result['language'], isNull);
        expect(result['publisher'], isNull);
        expect(result['created_at'], isA<int>());
      });
    });

    group('fromDatabaseJson', () {
      test('should create BookModel from database JSON', () {
        // arrange
        final json = {
          'id': '1',
          'title': 'Flutter in Action',
          'authors': 'Eric Windmill',
          'cover_image_url': 'https://example.com/cover1.jpg',
          'description': 'A comprehensive guide to Flutter development',
          'publish_date': '2019',
          'subjects': 'Programming,Mobile Development',
          'page_count': 300,
          'isbn': '9781617295997',
          'language': 'en',
          'publisher': 'Manning Publications',
        };

        // act
        final result = BookModel.fromDatabaseJson(json);

        // assert
        expect(result.id, '1');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, ['Eric Windmill']);
        expect(result.coverImageUrl, 'https://example.com/cover1.jpg');
        expect(result.description, 'A comprehensive guide to Flutter development');
        expect(result.publishDate, '2019');
        expect(result.subjects, ['Programming', 'Mobile Development']);
        expect(result.pageCount, 300);
        expect(result.isbn, '9781617295997');
        expect(result.language, 'en');
        expect(result.publisher, 'Manning Publications');
      });

      test('should handle null values in database JSON', () {
        // arrange
        final json = {
          'id': '1',
          'title': 'Flutter in Action',
          'authors': 'Eric Windmill',
          'cover_image_url': null,
          'description': null,
          'publish_date': null,
          'subjects': null,
          'page_count': null,
          'isbn': null,
          'language': null,
          'publisher': null,
        };

        // act
        final result = BookModel.fromDatabaseJson(json);

        // assert
        expect(result.id, '1');
        expect(result.title, 'Flutter in Action');
        expect(result.authors, ['Eric Windmill']);
        expect(result.coverImageUrl, isNull);
        expect(result.description, isNull);
        expect(result.publishDate, isNull);
        expect(result.subjects, isNull);
        expect(result.pageCount, isNull);
        expect(result.isbn, isNull);
        expect(result.language, isNull);
        expect(result.publisher, isNull);
      });

      test('should handle empty authors string', () {
        // arrange
        final json = {
          'id': '1',
          'title': 'Flutter in Action',
          'authors': '',
        };

        // act
        final result = BookModel.fromDatabaseJson(json);

        // assert
        expect(result.authors, ['']); // Empty string becomes [''] when split
      });

      test('should handle empty subjects string', () {
        // arrange
        final json = {
          'id': '1',
          'title': 'Flutter in Action',
          'authors': 'Eric Windmill',
          'subjects': '',
        };

        // act
        final result = BookModel.fromDatabaseJson(json);

        // assert
        expect(result.subjects, ['']); // Empty string becomes [''] when split
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // arrange
        const bookModel1 = BookModel(
          id: '1',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
        );
        const bookModel2 = BookModel(
          id: '1',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
        );

        // assert
        expect(bookModel1, equals(bookModel2));
      });

      test('should not be equal when properties are different', () {
        // arrange
        const bookModel1 = BookModel(
          id: '1',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
        );
        const bookModel2 = BookModel(
          id: '2',
          title: 'Flutter in Action',
          authors: ['Eric Windmill'],
        );

        // assert
        expect(bookModel1, isNot(equals(bookModel2)));
      });
    });
  });
}
