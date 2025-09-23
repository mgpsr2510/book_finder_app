import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../network/network_info.dart';
import 'database_helper.dart';
import 'web_database_helper.dart';
import '../../data/datasources/book_remote_datasource.dart';
import '../../data/datasources/book_web_remote_datasource.dart';
import '../../data/datasources/book_local_datasource.dart';
import '../../data/datasources/book_web_local_datasource.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/repositories/book_web_repository_impl.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/search_books.dart';
import '../../domain/usecases/get_book_details.dart';
import '../../domain/usecases/save_book.dart';
import '../../domain/usecases/get_saved_books.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../../presentation/bloc/book_details/book_details_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  // External
  sl.registerLazySingleton<Dio>(() => Dio());
  
  // Database
  if (kIsWeb) {
    sl.registerLazySingleton<WebDatabaseHelper>(() => WebDatabaseHelper());
  } else {
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  }
  
  // Data sources
  if (kIsWeb) {
    sl.registerLazySingleton<BookRemoteDataSource>(
      () => BookWebRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<BookWebLocalDataSource>(
      () => BookWebLocalDataSourceImpl(sl()),
    );
  } else {
    sl.registerLazySingleton<BookRemoteDataSource>(
      () => BookRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<BookLocalDataSource>(
      () => BookLocalDataSourceImpl(sl<DatabaseHelper>()),
    );
  }
  
  // Repository
  if (kIsWeb) {
    sl.registerLazySingleton<BookRepository>(
      () => BookWebRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  } else {
    sl.registerLazySingleton<BookRepository>(
      () => BookRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  }
  
  // Use cases
  sl.registerLazySingleton(() => SearchBooks(sl()));
  sl.registerLazySingleton(() => GetBookDetails(sl()));
  sl.registerLazySingleton(() => SaveBook(sl()));
  sl.registerLazySingleton(() => GetSavedBooks(sl()));
  
  // Bloc
  sl.registerFactory(() => SearchBloc(sl()));
  sl.registerFactory(() => BookDetailsBloc(sl(), sl(), sl()));
}
