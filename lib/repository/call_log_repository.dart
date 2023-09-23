import 'package:files_sync/database/database.dart';
import 'package:files_sync/repository/models/call_log_group.dart';
import 'package:sqflite/sqflite.dart';

class CallLogRepository {

  final Future<Database> _db = DatabaseService().database;

  Future<int> insertAccount(CallLogGroup callLogGroup) async {

    int newId = 0;
    await _db.then((db) => db.insert('logs', callLogGroup.toMap())).then((value) {
      newId = value;
    });
    return newId;
  }

  // Future<void> updateAccount(int accountId, Account account) async {
  //   await _db.then((db) => db.update('account', account.toMap(),
  //       where: 'id = ?', whereArgs: [accountId]));
  // }

  Future<void> deleteAllContacts() async {
    await _db.then((db) => db.rawDelete('DELETE FROM logs'));
  }

  Future<List<CallLogGroup>> getAllCallLogs() async {
    final List<Map<String, dynamic>> maps = await _db.then((db) => db.query('logs'));
    return List.generate(maps.length, (index) => CallLogGroup.fromMap(maps[index]));
  }

  // Future<Account> getAccountById(int id) async {
  //   final List<Map<String, dynamic>> maps = await _db.then((db) => db.rawQuery(
  //     'SELECT * FROM account WHERE id = ?',
  //     [id],
  //   ));
  //   return Account.fromMap(maps[0]);
  // }
}
