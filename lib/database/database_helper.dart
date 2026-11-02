import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/item.dart';

class DatabaseOperationException implements Exception {
  const DatabaseOperationException(this.operation, this.message);

  final String operation;
  final String message;

  @override
  String toString() => 'DatabaseOperationException($operation): $message';
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static DatabaseHelper forTesting(
    DatabaseFactory factory,
    String databasePath,
  ) {
    return DatabaseHelper._(
      databaseFactoryOverride: factory,
      databasePathOverride: databasePath,
    );
  }

  static const String _databaseName = 'campus_lost_found.db';
  static const String _itemsTable = 'items';

  final DatabaseFactory? databaseFactoryOverride;
  final String? databasePathOverride;
  Database? _database;

  DatabaseHelper._({this.databaseFactoryOverride, this.databasePathOverride});

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    try {
      final factory = databaseFactoryOverride ?? databaseFactory;
      final path =
          databasePathOverride ??
          p.join(await factory.getDatabasesPath(), _databaseName);

      return await factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE $_itemsTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                itemName TEXT NOT NULL,
                description TEXT NOT NULL,
                location TEXT NOT NULL,
                date TEXT NOT NULL,
                type TEXT NOT NULL,
                imagePath TEXT,
                status TEXT NOT NULL
              )
            ''');
          },
        ),
      );
    } catch (error) {
      throw DatabaseOperationException('initialize', error.toString());
    }
  }

  Future<int> insertItem(Item item) async {
    _validateItem(item);

    try {
      final db = await database;
      final values = item.toMap();
      values.remove('id');
      return await db.insert(
        _itemsTable,
        values,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (error) {
      throw DatabaseOperationException('insert', error.toString());
    }
  }

  Future<List<Item>> getAllItems() async {
    try {
      final db = await database;
      final maps = await db.query(_itemsTable, orderBy: 'id DESC');
      return maps.map(Item.fromMap).toList();
    } catch (error) {
      throw DatabaseOperationException('retrieve all', error.toString());
    }
  }

  Future<Item?> getItemById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        _itemsTable,
        where: 'id = ?',
        whereArgs: <Object?>[id],
        limit: 1,
      );
      return maps.isEmpty ? null : Item.fromMap(maps.first);
    } catch (error) {
      throw DatabaseOperationException('retrieve by ID', error.toString());
    }
  }

  Future<int> updateItem(Item item) async {
    if (item.id == null) {
      throw ArgumentError(
        'An existing item must have an id before it can be updated.',
      );
    }
    _validateItem(item);

    try {
      final db = await database;
      final values = item.toMap();
      values.remove('id');
      return await db.update(
        _itemsTable,
        values,
        where: 'id = ?',
        whereArgs: <Object?>[item.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (error) {
      throw DatabaseOperationException('update', error.toString());
    }
  }

  Future<int> deleteItem(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _itemsTable,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
    } catch (error) {
      throw DatabaseOperationException('delete', error.toString());
    }
  }

  Future<List<Item>> searchItems(String name) async {
    final searchName = name.trim();

    try {
      final db = await database;
      final maps = await db.query(
        _itemsTable,
        where: 'itemName LIKE ? COLLATE NOCASE',
        whereArgs: <Object?>['%$searchName%'],
        orderBy: 'id DESC',
      );
      return maps.map(Item.fromMap).toList();
    } catch (error) {
      throw DatabaseOperationException('search', error.toString());
    }
  }

  Future<List<Item>> filterItems({String? type, String? status}) async {
    final conditions = <String>[];
    final arguments = <Object?>[];

    if (type != null && type.isNotEmpty && type != 'All') {
      if (type != 'Lost' && type != 'Found') {
        throw ArgumentError.value(type, 'type', 'Type must be Lost or Found.');
      }
      conditions.add('type = ?');
      arguments.add(type);
    }

    if (status != null && status.isNotEmpty && status != 'All') {
      if (!const {'Pending', 'Claimed', 'Returned'}.contains(status)) {
        throw ArgumentError.value(status, 'status', 'Invalid item status.');
      }
      conditions.add('status = ?');
      arguments.add(status);
    }

    try {
      final db = await database;
      final maps = await db.query(
        _itemsTable,
        where: conditions.isEmpty ? null : conditions.join(' AND '),
        whereArgs: arguments.isEmpty ? null : arguments,
        orderBy: 'id DESC',
      );
      return maps.map(Item.fromMap).toList();
    } catch (error) {
      throw DatabaseOperationException('filter', error.toString());
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  void _validateItem(Item item) {
    final requiredFields = <String, String>{
      'itemName': item.itemName,
      'description': item.description,
      'location': item.location,
      'date': item.date,
      'type': item.type,
      'status': item.status,
    };

    for (final entry in requiredFields.entries) {
      if (entry.value.trim().isEmpty) {
        throw ArgumentError('${entry.key} is required.');
      }
    }

    if (item.type != 'Lost' && item.type != 'Found') {
      throw ArgumentError.value(
        item.type,
        'type',
        'Type must be Lost or Found.',
      );
    }

    if (!const {'Pending', 'Claimed', 'Returned'}.contains(item.status)) {
      throw ArgumentError.value(item.status, 'status', 'Invalid item status.');
    }
  }
}
