import 'package:sqflite/sqflite.dart' as sql;

class SQL_function {
  static Future<sql.Database> openDb() async {
    return sql.openDatabase('taskellate', version: 1,
        onCreate: (sql.Database db, int version) async {
      await createTable(db);
    });
  }

  static Future<void> createTable(sql.Database db) async {
    await db.execute(
        'CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, content TEXT, datetime DATETIME)');
  }

  static Future<int> newtask(
      String title, String content, DateTime datetime) async {
    var db = await SQL_function.openDb();
    var data = {
      'title': title,
      'content': content,
      'datetime': datetime.millisecondsSinceEpoch
    };
    var id = db.insert('todo', data);
    return id;
  }

  static Future<List<Map<String, dynamic>>> fetchalltask() async {
    var db = await SQL_function.openDb();
    var alltasks = await db.rawQuery('SELECT * FROM todo');
    return alltasks;
  }

  static Future<void> deletetask(int id) async {
    var db = await SQL_function.openDb();
    db.delete('todo', where: 'id=?', whereArgs: [id]);
  }

  static Future<int> updatetask(
      int id, String title, String content, DateTime date) async {
    var db = await SQL_function.openDb();
    final newdata = {
      'title': title,
      'content': content,
      'datetime': date.millisecondsSinceEpoch
    };
    final newid =
        await db.update('todo', newdata, where: 'id=?', whereArgs: [id]);
    return newid;
  }
}
