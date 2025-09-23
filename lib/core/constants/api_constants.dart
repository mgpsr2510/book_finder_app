class ApiConstants {
  static const String baseUrl = 'https://openlibrary.org';
  static const String searchEndpoint = '/search.json';
  static const String bookDetailsEndpoint = '/works';
  
  // API Parameters
  static const String titleParam = 'title';
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const int defaultLimit = 10;
  
  // Image URLs
  static const String coverImageBaseUrl = 'https://covers.openlibrary.org/b/id/';
  static const String coverImageSuffix = '-M.jpg';
  
  // Database
  static const String databaseName = 'book_finder.db';
  static const int databaseVersion = 1;
  static const String booksTable = 'books';
}

