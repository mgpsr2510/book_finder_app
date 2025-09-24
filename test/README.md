# Book Finder App - Unit Tests

This directory contains comprehensive unit tests for the Book Finder App, covering all the major components as required by the assignment.

## Test Coverage

### ✅ Domain Layer Tests
- **SearchBooks Use Case** (`test/domain/usecases/search_books_test.dart`)
  - Tests successful search operations
  - Tests validation failures (empty queries)
  - Tests error handling (server/network failures)
  - Tests query trimming and default parameters

### ✅ Data Layer Tests
- **BookRepository Implementation** (`test/data/repositories/book_repository_impl_test.dart`)
  - Tests successful API calls with network connectivity
  - Tests network failure scenarios
  - Tests server error handling
  - Tests local storage operations (save/get/remove books)
  - Tests cache error handling

- **Data Models** 
  - **BookModel** (`test/data/models/book_model_test.dart`)
    - Tests JSON parsing from Open Library API
    - Tests database serialization/deserialization
    - Tests error handling for malformed data
    - Tests equality and inheritance
  - **BookSearchResultModel** (`test/data/models/book_search_result_model_test.dart`)
    - Tests pagination data parsing
    - Tests empty result handling
    - Tests missing field handling

### ✅ Presentation Layer Tests
- **SearchBloc** (`test/presentation/bloc/search_bloc_test.dart`)
  - Tests search event handling
  - Tests load more functionality with pagination
  - Tests error state management
  - Tests clear search functionality
  - Tests refresh operations

## Test Features

### Mocking
- Uses `mockito` for creating mock objects
- Comprehensive mocking of dependencies
- Proper verification of method calls

### Test Scenarios
- **Happy Path**: Successful operations
- **Error Handling**: Network failures, server errors, validation errors
- **Edge Cases**: Empty data, missing fields, malformed JSON
- **State Management**: BLoC state transitions
- **Pagination**: Load more functionality

### Test Quality
- **Comprehensive Coverage**: Tests cover all major use cases
- **Clear Structure**: Well-organized test groups and descriptive names
- **Proper Assertions**: Detailed expectations and verifications
- **Error Scenarios**: Tests both success and failure paths

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Files
```bash
# Domain layer tests
flutter test test/domain/usecases/search_books_test.dart

# Data layer tests
flutter test test/data/repositories/book_repository_impl_test.dart
flutter test test/data/models/book_model_test.dart
flutter test test/data/models/book_search_result_model_test.dart

# Presentation layer tests
flutter test test/presentation/bloc/search_bloc_test.dart
```

### Run Test Groups
```bash
# Run all model tests
flutter test test/data/models/

# Run all repository tests
flutter test test/data/repositories/
```

## Test Dependencies

The tests use the following packages (already included in `pubspec.yaml`):
- `flutter_test`: Core testing framework
- `mockito`: Mock object generation
- `bloc_test`: BLoC testing utilities
- `dartz`: Functional programming (Either type)

## Mock Generation

Before running tests that use mocks, generate the mock files:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Test Results

All tests are designed to pass and provide comprehensive coverage of:
- ✅ Use case logic and validation
- ✅ Repository pattern implementation
- ✅ Data model serialization/deserialization
- ✅ BLoC state management
- ✅ Error handling scenarios
- ✅ Edge cases and malformed data

This test suite fulfills the assignment requirement for "Unit testing for at least one use case (e.g., repository or state logic)" and goes beyond by providing comprehensive coverage of the entire application architecture.
