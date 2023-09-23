import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = 'contacts.db';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    // ignore: avoid_print
    print("DATABASE PATH :: $path");
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create category table
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY,
        displayName TEXT NOT NULL,
        givenName TEXT NOT NULL,
        middleName TEXT NOT NULL,
        familyName TEXT NOT NULL,
        prefix TEXT NOT NULL,
        phones TEXT NOT NULL,
        birthday TEXT NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE logs(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        number TEXT NOT NULL,
        formattedNumber TEXT NOT NULL,
        callType TEXT NOT NULL,
        duration INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        cachedNumberType INTEGER NOT NULL,
        cachedNumberLabel TEXT NOT NULL,
        simDisplayName TEXT NOT NULL,
        cachedMatchedNumber TEXT NOT NULL,
        phoneAccountId TEXT NOT NULL
      )
      ''');

  }




}
