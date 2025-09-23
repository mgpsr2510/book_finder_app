import 'package:equatable/equatable.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final String bookId;

  const LoadBookDetailsEvent({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class SaveBookEvent extends BookDetailsEvent {
  const SaveBookEvent();
}

class RemoveBookEvent extends BookDetailsEvent {
  const RemoveBookEvent();
}

