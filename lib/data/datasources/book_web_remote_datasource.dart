import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/book_model.dart';
import '../models/book_search_result_model.dart';
import 'book_remote_datasource.dart';

class BookWebRemoteDataSourceImpl implements BookRemoteDataSource {
  final Dio dio;

  BookWebRemoteDataSourceImpl(this.dio);

  @override
  Future<BookSearchResultModel> searchBooks({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Use a different approach - try direct request with proper headers
      final targetUrl = '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?'
          '${ApiConstants.titleParam}=$query&'
          '${ApiConstants.pageParam}=$page&'
          '${ApiConstants.limitParam}=$limit';
      
      // Try multiple CORS proxy services as fallback
      final encodedUrl = Uri.encodeComponent(targetUrl);
      final proxyServices = [
        'https://api.allorigins.win/raw?url=',
        'https://corsproxy.io/?',
        'https://api.codetabs.com/v1/proxy?quest=',
        'https://thingproxy.freeboard.io/fetch/',
      ];
      
      for (final proxyUrl in proxyServices) {
        try {
          final response = await dio.get(
            '$proxyUrl$encodedUrl',
            options: Options(
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          );
          if (response.statusCode == 200) {
            return BookSearchResultModel.fromOpenLibraryJson(response.data);
          }
        } catch (e) {
          // Try next proxy service
          continue;
        }
      }
      
      throw const ServerException(message: 'Failed to search books - All CORS proxies failed');
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
      final targetUrl = '${ApiConstants.baseUrl}$fullBookId.json';
      
      // Try multiple CORS proxy services as fallback
      final encodedUrl = Uri.encodeComponent(targetUrl);
      final proxyServices = [
        'https://api.allorigins.win/raw?url=',
        'https://corsproxy.io/?',
        'https://api.codetabs.com/v1/proxy?quest=',
        'https://thingproxy.freeboard.io/fetch/',
      ];
      
      for (final proxyUrl in proxyServices) {
        try {
          final response = await dio.get(
            '$proxyUrl$encodedUrl',
            options: Options(
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          );
          if (response.statusCode == 200) {
            return BookModel.fromOpenLibraryWorkJson(response.data);
          }
        } catch (e) {
          // Try next proxy service
          continue;
        }
      }
      
      throw const ServerException(message: 'Failed to get book details - All CORS proxies failed');
    } on DioException catch (e) {
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
      throw const ServerException(message: 'Unexpected error occurred');
    }
  }
}
