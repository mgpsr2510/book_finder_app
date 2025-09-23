import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/book_model.dart';
import '../models/book_search_result_model.dart';

abstract class BookRemoteDataSource {
  Future<BookSearchResultModel> searchBooks({
    required String query,
    int page = 1,
    int limit = 10,
  });
  
  Future<BookModel> getBookDetails(String bookId);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final Dio dio;

  BookRemoteDataSourceImpl(this.dio);

  @override
  Future<BookSearchResultModel> searchBooks({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}',
        queryParameters: {
          ApiConstants.titleParam: query,
          ApiConstants.pageParam: page,
          ApiConstants.limitParam: limit,
        },
      );

      if (response.statusCode == 200) {
        return BookSearchResultModel.fromOpenLibraryJson(response.data);
      } else {
        throw const ServerException(message: 'Failed to search books');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw const ServerException(message: 'Failed to search books');
      }
    } catch (e) {
      throw const ServerException(message: 'Unexpected error occurred');
    }
  }

  @override
  Future<BookModel> getBookDetails(String bookId) async {
    try {
      // Ensure bookId has the /works/ prefix for the API call
      final fullBookId = bookId.startsWith('/works/') ? bookId : '/works/$bookId';
      final url = '${ApiConstants.baseUrl}$fullBookId.json';
      print('Fetching book details from: $url');
      
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        print('Book details API response received');
        return BookModel.fromOpenLibraryWorkJson(response.data);
      } else {
        print('Book details API failed with status: ${response.statusCode}');
        throw const ServerException(message: 'Failed to get book details');
      }
    } on DioException catch (e) {
      print('DioException in getBookDetails: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw const ServerException(message: 'Failed to get book details');
      }
    } catch (e) {
      print('Unexpected error in getBookDetails: $e');
      throw const ServerException(message: 'Unexpected error occurred');
    }
  }
}

