import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = ApiConstants.databaseName;
  static const int _databaseVersion = ApiConstants.databaseVersion;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      // Initialize FFI for web platforms
      if (kIsWeb) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      
      String path = join(await getDatabasesPath(), _databaseName);
      print('Database path: $path');
      
      final database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      
      print('Database opened successfully');
      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creating database table: ${ApiConstants.booksTable}');
    await db.execute('''
      CREATE TABLE ${ApiConstants.booksTable} (
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
      )
    ''');
    print('Database table created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < newVersion) {
      // For now, just recreate the table
      await db.execute('DROP TABLE IF EXISTS ${ApiConstants.booksTable}');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

