import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:book_finder_app/domain/entities/book.dart';
import 'package:book_finder_app/domain/entities/book_search_result.dart';
import 'package:book_finder_app/domain/repositories/book_repository.dart';
import 'package:book_finder_app/domain/usecases/search_books.dart';
import 'package:book_finder_app/core/error/failures.dart';

import 'search_books_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  late SearchBooks usecase;
  late MockBookRepository mockBookRepository;

  setUp(() {
    mockBookRepository = MockBookRepository();
    usecase = SearchBooks(mockBookRepository);
  });

  const String tQuery = 'flutter';
  const int tPage = 1;
  const int tLimit = 10;

  final List<Book> tBooks = [
    const Book(
      id: '1',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      coverImageUrl: 'https://example.com/cover1.jpg',
      publishDate: '2019',
    ),
    const Book(
      id: '2',
      title: 'Flutter Complete Reference',
      authors: ['Alberto Miola'],
      coverImageUrl: 'https://example.com/cover2.jpg',
      publishDate: '2020',
    ),
  ];

  final BookSearchResult tSearchResult = BookSearchResult(
    books: tBooks,
    totalCount: 100,
    currentPage: 1,
    hasNextPage: true,
  );

  group('SearchBooks', () {
    test('should return BookSearchResult when repository call is successful', () async {
      // arrange
      when(mockBookRepository.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Right(tSearchResult));

      // act
      final result = await usecase(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, Right(tSearchResult));
      verify(mockBookRepository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
      verifyNoMoreInteractions(mockBookRepository);
    });

    test('should return ValidationFailure when query is empty', () async {
      // act
      final result = await usecase(query: '');

      // assert
      expect(result, const Left(ValidationFailure(message: 'Search query cannot be empty')));
      verifyZeroInteractions(mockBookRepository);
    });

    test('should return ValidationFailure when query is only whitespace', () async {
      // act
      final result = await usecase(query: '   ');

      // assert
      expect(result, const Left(ValidationFailure(message: 'Search query cannot be empty')));
      verifyZeroInteractions(mockBookRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      when(mockBookRepository.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));

      // act
      final result = await usecase(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockBookRepository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
      verifyNoMoreInteractions(mockBookRepository);
    });

    test('should return NetworkFailure when repository call fails with network error', () async {
      // arrange
      when(mockBookRepository.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

      // act
      final result = await usecase(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verify(mockBookRepository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
      verifyNoMoreInteractions(mockBookRepository);
    });

    test('should trim whitespace from query before calling repository', () async {
      // arrange
      when(mockBookRepository.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Right(tSearchResult));

      // act
      await usecase(query: '  flutter  ');

      // assert
      verify(mockBookRepository.searchBooks(
        query: 'flutter', // Should be trimmed
        page: 1,
        limit: 10,
      ));
    });

    test('should use default values for page and limit when not provided', () async {
      // arrange
      when(mockBookRepository.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Right(tSearchResult));

      // act
      await usecase(query: tQuery);

      // assert
      verify(mockBookRepository.searchBooks(
        query: tQuery,
        page: 1, // Default page
        limit: 10, // Default limit
      ));
    });
  });
}
