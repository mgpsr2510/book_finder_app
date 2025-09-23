import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_book_details.dart';
import '../../../domain/usecases/save_book.dart';
import '../../../domain/usecases/get_saved_books.dart';
import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBookDetails getBookDetails;
  final SaveBook saveBook;
  final GetSavedBooks getSavedBooks;

  BookDetailsBloc(
    this.getBookDetails,
    this.saveBook,
    this.getSavedBooks,
  ) : super(const BookDetailsInitial()) {
    on<LoadBookDetailsEvent>(_onLoadBookDetails);
    on<SaveBookEvent>(_onSaveBook);
    on<RemoveBookEvent>(_onRemoveBook);
  }

  Future<void> _onLoadBookDetails(
    LoadBookDetailsEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    emit(const BookDetailsLoading());
    print('Loading book details for ID: ${event.bookId}');

    final result = await getBookDetails(event.bookId);

    result.fold(
      (failure) {
        print('Error loading book details: ${failure.message}');
        if (!emit.isDone) {
          emit(BookDetailsError(message: failure.message));
        }
      },
      (book) async {
        print('Book details loaded successfully: ${book.title}');
        // For now, skip the saved books check to isolate the issue
        bool isSaved = false;

        if (!emit.isDone) {
          emit(BookDetailsLoaded(book: book, isSaved: isSaved));
        }
      },
    );
  }

  Future<void> _onSaveBook(
    SaveBookEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    if (state is BookDetailsLoaded) {
      final currentState = state as BookDetailsLoaded;
      
      final result = await saveBook(currentState.book);

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(BookDetailsError(message: failure.message)),
          (_) => emit(BookDetailsLoaded(book: currentState.book, isSaved: true)),
        );
      }
    }
  }

  Future<void> _onRemoveBook(
    RemoveBookEvent event,
    Emitter<BookDetailsState> emit,
  ) async {
    if (state is BookDetailsLoaded) {
      final currentState = state as BookDetailsLoaded;
      
      // Note: We would need a RemoveBook use case for this
      // For now, we'll just emit BookDetailsLoaded with isSaved: false
      if (!emit.isDone) {
        emit(BookDetailsLoaded(book: currentState.book, isSaved: false));
      }
    }
  }
}

