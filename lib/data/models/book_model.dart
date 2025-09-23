import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.coverImageUrl,
    super.description,
    super.publishDate,
    super.subjects,
    super.pageCount,
    super.isbn,
    super.language,
    super.publisher,
  });

  factory BookModel.fromBook(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      authors: book.authors,
      coverImageUrl: book.coverImageUrl,
      description: book.description,
      publishDate: book.publishDate,
      subjects: book.subjects,
      pageCount: book.pageCount,
      isbn: book.isbn,
      language: book.language,
      publisher: book.publisher,
    );
  }

  factory BookModel.fromOpenLibraryJson(Map<String, dynamic> json) {
    final work = json['work'] ?? json;
    final authors = <String>[];
    
    if (work['author_name'] != null) {
      if (work['author_name'] is List) {
        authors.addAll((work['author_name'] as List).cast<String>());
      } else {
        authors.add(work['author_name'].toString());
      }
    }
    
    String? coverImageUrl;
    if (work['cover_i'] != null) {
      coverImageUrl = 'https://covers.openlibrary.org/b/id/${work['cover_i']}-M.jpg';
    }
    
    return BookModel(
      id: work['key']?.toString().replaceAll('/works/', '') ?? '',
      title: work['title'] ?? 'Unknown Title',
      authors: authors,
      coverImageUrl: coverImageUrl,
      publishDate: work['first_publish_year']?.toString(),
      subjects: work['subject'] != null 
          ? (work['subject'] as List).cast<String>()
          : null,
    );
  }

  factory BookModel.fromOpenLibraryWorkJson(Map<String, dynamic> json) {
    try {
      print('Parsing book JSON: ${json.keys.toList()}');
      final authors = <String>[];
      
      if (json['authors'] != null) {
        for (final author in json['authors']) {
          if (author['author'] != null && author['author']['key'] != null) {
            authors.add(author['author']['key'].toString().replaceAll('/authors/', ''));
          } else if (author['key'] != null) {
            // Handle direct author key structure
            authors.add(author['key'].toString().replaceAll('/authors/', ''));
          }
        }
      }
      
      String? coverImageUrl;
      if (json['covers'] != null && (json['covers'] as List).isNotEmpty) {
        coverImageUrl = 'https://covers.openlibrary.org/b/id/${json['covers'][0]}-M.jpg';
      }
      
      final book = BookModel(
        id: json['key']?.toString().replaceAll('/works/', '') ?? '',
        title: json['title'] ?? 'Unknown Title',
        authors: authors,
        coverImageUrl: coverImageUrl,
        description: json['description'] != null 
            ? (json['description'] is String 
                ? json['description'] 
                : (json['description'] is Map && json['description']['value'] != null
                    ? json['description']['value']
                    : null))
            : null,
        publishDate: json['first_publish_date']?.toString(),
        subjects: json['subjects'] != null 
            ? (json['subjects'] as List).cast<String>()
            : null,
        pageCount: json['number_of_pages_median'],
        isbn: json['isbn_13'] != null 
            ? (json['isbn_13'] as List).first.toString()
            : json['isbn_10'] != null 
                ? (json['isbn_10'] as List).first.toString()
                : null,
        language: json['languages'] != null && (json['languages'] as List).isNotEmpty
            ? json['languages'][0]['key']?.toString().replaceAll('/languages/', '')
            : null,
        publisher: json['publishers'] != null && (json['publishers'] as List).isNotEmpty
            ? json['publishers'][0]['name']
            : null,
      );
      print('Book parsed successfully: ${book.title} by ${book.authors.join(', ')}');
      return book;
    } catch (e) {
      print('Error parsing book JSON: $e');
      // Return a basic book model with available data
      return BookModel(
        id: json['key']?.toString().replaceAll('/works/', '') ?? '',
        title: json['title'] ?? 'Unknown Title',
        authors: [],
        coverImageUrl: null,
        description: null,
        publishDate: json['first_publish_date']?.toString(),
        subjects: null,
        pageCount: null,
        isbn: null,
        language: null,
        publisher: null,
      );
    }
  }

  Map<String, dynamic> toDatabaseJson() => {
    'id': id,
    'title': title,
    'authors': authors.join(','),
    'cover_image_url': coverImageUrl,
    'description': description,
    'publish_date': publishDate,
    'subjects': subjects?.join(','),
    'page_count': pageCount,
    'isbn': isbn,
    'language': language,
    'publisher': publisher,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  };

  factory BookModel.fromDatabaseJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      authors: json['authors']?.split(',') ?? [],
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
      publishDate: json['publish_date'],
      subjects: json['subjects']?.split(','),
      pageCount: json['page_count'],
      isbn: json['isbn'],
      language: json['language'],
      publisher: json['publisher'],
    );
  }
}