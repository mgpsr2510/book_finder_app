import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';

abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object?> get props => [];
}

class BookDetailsInitial extends BookDetailsState {
  const BookDetailsInitial();
}

class BookDetailsLoading extends BookDetailsState {
  const BookDetailsLoading();
}

class BookDetailsLoaded extends BookDetailsState {
  final Book book;
  final bool isSaved;

  const BookDetailsLoaded({
    required this.book,
    required this.isSaved,
  });

  @override
  List<Object> get props => [book, isSaved];
}

class BookDetailsError extends BookDetailsState {
  final String message;

  const BookDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookSaved extends BookDetailsState {
  const BookSaved();
}

class BookRemoved extends BookDetailsState {
  const BookRemoved();
}

