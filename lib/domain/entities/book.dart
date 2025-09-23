import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final List<String> authors;
  final String? coverImageUrl;
  final String? description;
  final String? publishDate;
  final List<String>? subjects;
  final int? pageCount;
  final String? isbn;
  final String? language;
  final String? publisher;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.coverImageUrl,
    this.description,
    this.publishDate,
    this.subjects,
    this.pageCount,
    this.isbn,
    this.language,
    this.publisher,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        coverImageUrl,
        description,
        publishDate,
        subjects,
        pageCount,
        isbn,
        language,
        publisher,
      ];
}

