import 'package:files_sync/repository/models/contacts_group.dart';
import 'package:files_sync/database/database.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {

  final Future<Database> _db = DatabaseService().database;

  Future<int> insertAccount(ContactGroup contactGroup) async {

    int newId = 0;
    await _db.then((db) => db.insert('contacts', contactGroup.toMap())).then((value) {
      newId = value;
    });
    return newId;
  }

  // Future<void> updateAccount(int accountId, Account account) async {
  //   await _db.then((db) => db.update('account', account.toMap(),
  //       where: 'id = ?', whereArgs: [accountId]));
  // }

  Future<void> deleteAllContacts() async {
    await _db.then((db) => db.rawDelete('DELETE FROM contacts'));
  }

  Future<List<ContactGroup>> getAllContacts() async {
    final List<Map<String, dynamic>> maps = await _db.then((db) => db.query('contacts'));
    return List.generate(maps.length, (index) => ContactGroup.fromMap(maps[index]));
  }

  // Future<Account> getAccountById(int id) async {
  //   final List<Map<String, dynamic>> maps = await _db.then((db) => db.rawQuery(
  //     'SELECT * FROM account WHERE id = ?',
  //     [id],
  //   ));
  //   return Account.fromMap(maps[0]);
  // }
}
