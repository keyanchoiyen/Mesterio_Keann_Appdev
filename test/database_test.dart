import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campus_lost_found/database/database_helper.dart';
import 'package:campus_lost_found/models/item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late DatabaseHelper database;

  setUp(() {
    database = DatabaseHelper.forTesting(databaseFactoryFfi, ':memory:');
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'inserts, retrieves, updates, searches, filters and deletes an item',
    () async {
      final insertedId = await database.insertItem(
        const Item(
          itemName: 'Black Wallet',
          description: 'A small leather wallet.',
          location: 'Library',
          date: 'November 2, 2026',
          type: 'Lost',
          imagePath: 'wallet.jpg',
          status: 'Pending',
        ),
      );

      expect(insertedId, greaterThan(0));

      final retrieved = await database.getItemById(insertedId);
      expect(retrieved?.itemName, 'Black Wallet');

      final searched = await database.searchItems('wallet');
      expect(searched, hasLength(1));

      final filtered = await database.filterItems(
        type: 'Lost',
        status: 'Pending',
      );
      expect(filtered, hasLength(1));

      final updated = retrieved!.copyWith(status: 'Claimed');
      expect(await database.updateItem(updated), 1);
      expect((await database.getItemById(insertedId))?.status, 'Claimed');

      expect(await database.deleteItem(insertedId), 1);
      expect(await database.getAllItems(), isEmpty);
    },
  );

  test('handles empty image paths and defaults status to Pending', () {
    const item = Item(
      itemName: 'Keys',
      description: 'A set of keys.',
      location: 'Cafeteria',
      date: 'November 2, 2026',
      type: 'Found',
      imagePath: '',
    );

    final map = item.toMap();
    expect(map['imagePath'], isNull);
    expect(map['status'], 'Pending');

    final restored = Item.fromMap(map);
    expect(restored.imagePath, isNull);
    expect(restored.status, 'Pending');
  });

  test('rejects invalid item values', () async {
    expect(
      () => database.insertItem(
        const Item(
          itemName: '',
          description: 'Description',
          location: 'Location',
          date: 'November 2, 2026',
          type: 'Lost',
        ),
      ),
      throwsArgumentError,
    );
  });
}
