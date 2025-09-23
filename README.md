# Book Finder App

A Flutter application that allows users to search for books using the Open Library API with clean architecture, BLoC state management, and local SQLite storage.

## Features

- **Search Books**: Search for books by title using the Open Library API
- **Book Details**: View detailed information about books with animated cover rotation
- **Local Storage**: Save books locally using SQLite database with proper schema
- **Save/Remove Books**: Save books to local collection with success/remove notifications
- **Pull-to-Refresh**: Refresh search results with pull-to-refresh gesture
- **Shimmer Loading**: Beautiful shimmer loading animations
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Clean Architecture**: Well-structured code following clean architecture principles
- **BLoC State Management**: Reactive state management using BLoC pattern
- **Dependency Injection**: Proper DI setup with GetIt for testable code
- **Responsive Design**: Mobile and desktop layouts with adaptive UI
- **Snackbar Notifications**: User feedback for save/remove operations

## Architecture

The app follows Clean Architecture principles with three main layers:

### 1. Presentation Layer (`lib/presentation/`)
- **BLoC**: State management using flutter_bloc
- **Pages**: UI screens (Search, Book Details)
- **Widgets**: Reusable UI components

### 2. Domain Layer (`lib/domain/`)
- **Entities**: Core business objects (Book, BookSearchResult)
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Business logic implementation

### 3. Data Layer (`lib/data/`)
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Remote (API) and Local (SQLite) data sources
- **Repositories**: Concrete implementations of domain repositories

### 4. Core Layer (`lib/core/`)
- **Constants**: API endpoints and configuration
- **Error**: Failure and exception handling
- **Network**: Network connectivity checking
- **DI**: Dependency injection setup

## Dependencies

- **flutter_bloc**: State management
- **dio**: HTTP client for API calls
- **sqflite**: Local SQLite database
- **cached_network_image**: Image caching and loading
- **shimmer**: Loading animations
- **dartz**: Functional programming utilities
- **equatable**: Value equality
- **get_it**: Dependency injection

## Recent Updates & Fixes

### Version 1.1.0 - Current Implementation
- ✅ **Fixed Database Dependency Injection**: Resolved GetIt registration conflicts
- ✅ **Enhanced Book Saving**: Fixed database schema and save functionality
- ✅ **Added User Feedback**: Implemented snackbar notifications for save/remove actions
- ✅ **Improved Error Handling**: Added comprehensive debugging and error logging
- ✅ **Database Schema Fix**: Added missing `created_at` field for proper book storage
- ✅ **Code Cleanup**: Removed test files and optimized dependency injection

### Key Technical Improvements
- **DatabaseHelper Integration**: Books now use DatabaseHelper instead of direct Database injection
- **Proper State Management**: Fixed BookDetailsBloc state transitions
- **Enhanced UX**: Color-coded snackbar messages (green for save, orange for remove)
- **Debug Logging**: Added comprehensive logging for troubleshooting
- **Schema Validation**: Ensured all required database fields are populated

## Getting Started

1. **Prerequisites**
   - Flutter SDK (3.8.1 or higher)
   - Dart SDK
   - Android Studio / VS Code
   - Android/iOS device or emulator

2. **Installation**
   ```bash
   git clone https://github.com/mgpsr2510/book_finder_app.git
   cd book_finder_app
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Clean Build (if needed)**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## API Integration

The app integrates with the Open Library API:
- **Search Endpoint**: `https://openlibrary.org/search.json`
- **Book Details**: `https://openlibrary.org/works/{id}.json`
- **Cover Images**: `https://covers.openlibrary.org/b/id/{cover_id}-M.jpg`

## Database Schema

The SQLite database stores saved books with the following schema:
```sql
CREATE TABLE books (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  authors TEXT NOT NULL,
  cover_image_url TEXT,
  description TEXT,
  publish_date TEXT,
  subjects TEXT,
  page_count INTEGER,
  isbn TEXT,
  language TEXT,
  publisher TEXT,
  created_at INTEGER NOT NULL
);
```

## Testing

Run unit tests:
```bash
flutter test
```

The app includes comprehensive unit tests for:
- Repository implementations
- BLoC state management
- Use cases
- Data models

## Features in Detail

### Search Screen
- Search bar with real-time input
- Book results with cover images, titles, and authors
- Pull-to-refresh functionality
- Shimmer loading animations
- Pagination support
- Error handling with retry options

### Book Details Screen
- Animated book cover with rotation effect
- Complete book information display (title, authors, description, publish date, etc.)
- Save/Remove book functionality with visual feedback
- Snackbar notifications for user actions
- Beautiful gradient background
- Responsive design for mobile and desktop
- Real-time save status updates

### State Management
- **SearchBloc**: Manages search functionality and pagination
- **BookDetailsBloc**: Handles book details and save operations
- Reactive UI updates based on state changes
- Proper error state handling

## Error Handling

The app implements comprehensive error handling:
- **Network Errors**: No internet connection, timeouts
- **Server Errors**: API failures, invalid responses
- **Cache Errors**: Database operation failures
- **Validation Errors**: Input validation failures

## Performance Optimizations

- Image caching with `cached_network_image`
- Lazy loading for large lists
- Efficient state management with BLoC
- Database indexing for fast queries
- Memory-efficient image loading

## Implementation Status

### ✅ Completed Features
- [x] Book search functionality with Open Library API
- [x] Book details page with comprehensive information
- [x] Local SQLite database for saving books
- [x] Save/Remove book functionality
- [x] User feedback with snackbar notifications
- [x] Responsive design for mobile and desktop
- [x] Error handling and debugging
- [x] Clean architecture implementation
- [x] BLoC state management
- [x] Dependency injection setup
- [x] Database schema with proper fields
- [x] Image caching and loading
- [x] Pull-to-refresh functionality
- [x] Shimmer loading animations

### 🔧 Technical Implementation
- **Architecture**: Clean Architecture with 3 layers (Presentation, Domain, Data)
- **State Management**: BLoC pattern with flutter_bloc
- **Database**: SQLite with sqflite package
- **API Integration**: Open Library API with Dio HTTP client
- **Dependency Injection**: GetIt for service locator pattern
- **Error Handling**: Comprehensive error handling with Either pattern
- **UI/UX**: Material Design with custom animations and responsive layouts

### 📱 Current Version
- **Version**: 1.1.0
- **Flutter SDK**: 3.8.1+
- **Dart SDK**: 3.0.0+
- **Status**: Production Ready

## License

This project is licensed under the MIT License - see the LICENSE file for details.