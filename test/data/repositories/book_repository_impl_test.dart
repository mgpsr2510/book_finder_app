import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:book_finder_app/core/error/exceptions.dart';
import 'package:book_finder_app/core/error/failures.dart';
import 'package:book_finder_app/core/network/network_info.dart';
import 'package:book_finder_app/data/datasources/book_local_datasource.dart';
import 'package:book_finder_app/data/datasources/book_remote_datasource.dart';
import 'package:book_finder_app/data/models/book_model.dart';
import 'package:book_finder_app/data/models/book_search_result_model.dart';
import 'package:book_finder_app/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app/domain/entities/book.dart';
import 'package:book_finder_app/domain/entities/book_search_result.dart';

import 'book_repository_impl_test.mocks.dart';

@GenerateMocks([
  BookRemoteDataSource,
  BookLocalDataSource,
  NetworkInfo,
])
void main() {
  late BookRepositoryImpl repository;
  late MockBookRemoteDataSource mockRemoteDataSource;
  late MockBookLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockBookRemoteDataSource();
    mockLocalDataSource = MockBookLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BookRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('searchBooks', () {
    const String tQuery = 'flutter';
    const int tPage = 1;
    const int tLimit = 10;

    final List<BookModel> tBookModels = [
      const BookModel(
        id: '1',
        title: 'Flutter in Action',
        authors: ['Eric Windmill'],
        coverImageUrl: 'https://example.com/cover1.jpg',
        publishDate: '2019',
      ),
    ];

    final BookSearchResultModel tSearchResultModel = BookSearchResultModel(
      books: tBookModels,
      totalCount: 100,
      currentPage: 1,
      hasNextPage: true,
    );

    test('should return BookSearchResult when network is available and call is successful', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => tSearchResultModel);

      // act
      final result = await repository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, Right(tSearchResultModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return NetworkFailure when network is not available', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const ServerException(message: 'Server error'));

      // act
      final result = await repository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
    });

    test('should return NetworkFailure when remote data source throws NetworkException', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const NetworkException(message: 'Connection timeout'));

      // act
      final result = await repository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(NetworkFailure(message: 'Connection timeout')));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
    });

    test('should return ServerFailure when remote data source throws unexpected exception', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchBooks(
        query: anyNamed('query'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      );

      // assert
      expect(result, const Left(ServerFailure(message: 'Unexpected error occurred')));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.searchBooks(
        query: tQuery,
        page: tPage,
        limit: tLimit,
      ));
    });
  });

  group('getBookDetails', () {
    const String tBookId = '1';
    const BookModel tBookModel = BookModel(
      id: '1',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      coverImageUrl: 'https://example.com/cover1.jpg',
      publishDate: '2019',
    );

    test('should return Book when network is available and call is successful', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getBookDetails(any)).thenAnswer((_) async => tBookModel);

      // act
      final result = await repository.getBookDetails(tBookId);

      // assert
      expect(result, Right(tBookModel));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getBookDetails(tBookId));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return NetworkFailure when network is not available', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getBookDetails(tBookId);

      // assert
      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getBookDetails(any)).thenThrow(const ServerException(message: 'Server error'));

      // act
      final result = await repository.getBookDetails(tBookId);

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getBookDetails(tBookId));
    });
  });

  group('saveBook', () {
    const Book tBook = Book(
      id: '1',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      coverImageUrl: 'https://example.com/cover1.jpg',
      publishDate: '2019',
    );

    test('should return Right(null) when local data source call is successful', () async {
      // arrange
      when(mockLocalDataSource.saveBook(any)).thenAnswer((_) async {});

      // act
      final result = await repository.saveBook(tBook);

      // assert
      expect(result, const Right(null));
      verify(mockLocalDataSource.saveBook(any));
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.saveBook(any)).thenThrow(const CacheException(message: 'Cache error'));

      // act
      final result = await repository.saveBook(tBook);

      // assert
      expect(result, const Left(CacheFailure(message: 'Cache error')));
      verify(mockLocalDataSource.saveBook(any));
    });

    test('should return CacheFailure when local data source throws unexpected exception', () async {
      // arrange
      when(mockLocalDataSource.saveBook(any)).thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.saveBook(tBook);

      // assert
      expect(result, const Left(CacheFailure(message: 'Unexpected error occurred')));
      verify(mockLocalDataSource.saveBook(any));
    });
  });

  group('getSavedBooks', () {
    final List<BookModel> tSavedBooks = [
      const BookModel(
        id: '1',
        title: 'Flutter in Action',
        authors: ['Eric Windmill'],
        coverImageUrl: 'https://example.com/cover1.jpg',
        publishDate: '2019',
      ),
    ];

    test('should return List<Book> when local data source call is successful', () async {
      // arrange
      when(mockLocalDataSource.getSavedBooks()).thenAnswer((_) async => tSavedBooks);

      // act
      final result = await repository.getSavedBooks();

      // assert
      expect(result, Right(tSavedBooks));
      verify(mockLocalDataSource.getSavedBooks());
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.getSavedBooks()).thenThrow(const CacheException(message: 'Cache error'));

      // act
      final result = await repository.getSavedBooks();

      // assert
      expect(result, const Left(CacheFailure(message: 'Cache error')));
      verify(mockLocalDataSource.getSavedBooks());
    });
  });

  group('removeBook', () {
    const String tBookId = '1';

    test('should return Right(null) when local data source call is successful', () async {
      // arrange
      when(mockLocalDataSource.removeBook(any)).thenAnswer((_) async {});

      // act
      final result = await repository.removeBook(tBookId);

      // assert
      expect(result, const Right(null));
      verify(mockLocalDataSource.removeBook(tBookId));
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.removeBook(any)).thenThrow(const CacheException(message: 'Cache error'));

      // act
      final result = await repository.removeBook(tBookId);

      // assert
      expect(result, const Left(CacheFailure(message: 'Cache error')));
      verify(mockLocalDataSource.removeBook(tBookId));
    });
  });
}
