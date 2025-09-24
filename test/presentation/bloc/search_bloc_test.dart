import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:book_finder_app/domain/entities/book.dart';
import 'package:book_finder_app/domain/entities/book_search_result.dart';
import 'package:book_finder_app/domain/usecases/search_books.dart';
import 'package:book_finder_app/presentation/bloc/search/search_bloc.dart';
import 'package:book_finder_app/presentation/bloc/search/search_event.dart';
import 'package:book_finder_app/presentation/bloc/search/search_state.dart';
import 'package:book_finder_app/core/error/failures.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchBooks])
void main() {
  late SearchBloc searchBloc;
  late MockSearchBooks mockSearchBooks;

  setUp(() {
    mockSearchBooks = MockSearchBooks();
    searchBloc = SearchBloc(mockSearchBooks);
  });

  tearDown(() {
    searchBloc.close();
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

  group('SearchBloc', () {
    test('initial state should be SearchInitial', () {
      // assert
      expect(searchBloc.state, const SearchInitial());
    });

    group('SearchBooksEvent', () {
      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, SearchLoaded] when search is successful',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchBooksEvent(query: tQuery)),
        expect: () => [
          const SearchLoading(),
          SearchLoaded(
            searchResult: tSearchResult,
            allBooks: tBooks,
          ),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery,
            page: 1,
            limit: 10,
          )).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading, SearchError] when search fails',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchBooksEvent(query: tQuery)),
        expect: () => [
          const SearchLoading(),
          const SearchError(message: 'Server error'),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery,
            page: 1,
            limit: 10,
          )).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoading(isRefresh: true), SearchLoaded] when search is refresh',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchBooksEvent(
          query: tQuery,
          isRefresh: true,
        )),
        expect: () => [
          const SearchLoading(isRefresh: true),
          SearchLoaded(
            searchResult: tSearchResult,
            allBooks: tBooks,
          ),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery,
            page: 1,
            limit: 10,
          )).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should use custom page and limit values',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchBooksEvent(
          query: tQuery,
          page: 2,
          limit: 20,
        )),
        expect: () => [
          const SearchLoading(),
          SearchLoaded(
            searchResult: tSearchResult,
            allBooks: tBooks,
          ),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery,
            page: 2,
            limit: 20,
          )).called(1);
        },
      );
    });

    group('LoadMoreBooksEvent', () {
      final BookSearchResult tNextPageResult = BookSearchResult(
        books: [
          const Book(
            id: '3',
            title: 'Flutter Cookbook',
            authors: ['Simon Lightfoot'],
            coverImageUrl: 'https://example.com/cover3.jpg',
            publishDate: '2021',
          ),
        ],
        totalCount: 100,
        currentPage: 2,
        hasNextPage: false,
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchLoaded] with more books when load more is successful',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        seed: () => SearchLoaded(
          searchResult: tSearchResult,
          allBooks: tBooks,
        ),
        act: (bloc) {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tNextPageResult));
          bloc.add(const LoadMoreBooksEvent());
        },
        expect: () => [
          SearchLoaded(
            searchResult: tNextPageResult,
            allBooks: [...tBooks, ...tNextPageResult.books],
          ),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery, // Should use the first book's title as query
            page: 2, // Next page
            limit: 10,
          )).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit [SearchError] when load more fails',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        seed: () => SearchLoaded(
          searchResult: tSearchResult,
          allBooks: tBooks,
        ),
        act: (bloc) {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
          bloc.add(const LoadMoreBooksEvent());
        },
        expect: () => [
          const SearchError(message: 'Server error'),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'should not load more when hasNextPage is false',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        seed: () => SearchLoaded(
          searchResult: BookSearchResult(
            books: tBooks,
            totalCount: 100,
            currentPage: 1,
            hasNextPage: false, // No more pages
          ),
          allBooks: tBooks,
        ),
        act: (bloc) => bloc.add(const LoadMoreBooksEvent()),
        expect: () => [], // Should not emit anything
        verify: (_) {
          verifyNever(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ));
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should not load more when state is not SearchLoaded',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        seed: () => const SearchLoading(), // Not SearchLoaded
        act: (bloc) => bloc.add(const LoadMoreBooksEvent()),
        expect: () => [], // Should not emit anything
        verify: (_) {
          verifyNever(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ));
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should use custom limit for load more',
        build: () {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tSearchResult));
          return searchBloc;
        },
        seed: () => SearchLoaded(
          searchResult: tSearchResult,
          allBooks: tBooks,
        ),
        act: (bloc) {
          when(mockSearchBooks(
            query: anyNamed('query'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          )).thenAnswer((_) async => Right(tNextPageResult));
          bloc.add(const LoadMoreBooksEvent(limit: 20));
        },
        expect: () => [
          SearchLoaded(
            searchResult: tNextPageResult,
            allBooks: [...tBooks, ...tNextPageResult.books],
          ),
        ],
        verify: (_) {
          verify(mockSearchBooks(
            query: tQuery,
            page: 2,
            limit: 20, // Custom limit
          )).called(1);
        },
      );
    });

    group('ClearSearchEvent', () {
      blocTest<SearchBloc, SearchState>(
        'should emit [SearchInitial] when clear search is triggered',
        build: () => searchBloc,
        seed: () => SearchLoaded(
          searchResult: tSearchResult,
          allBooks: tBooks,
        ),
        act: (bloc) => bloc.add(const ClearSearchEvent()),
        expect: () => [
          const SearchInitial(),
        ],
        verify: (_) {
          verifyZeroInteractions(mockSearchBooks);
        },
      );
    });
  });
}
