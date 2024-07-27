// 从云端同步数据到本地

// 仅用本地数据
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// 数据表名
const tableName = 'TodoItem';

// 数据表创建SQL
const sql = '''
CREATE TABLE $tableName (
  id INTEGER PRIMARY KEY, 
  title TEXT,
  createTime INTEGER,
  isDone INTEGER,
  targetDateTime INTEGER,
  deleteTime INTEGER,
  content TEXT,
  location TEXT,
  flag INTEGER
)
''';

class DataObject {}

class TodoItem {
  final title;
  final isDone = 0;
  final deleteTime = 0;
  final content = '';
  final location = '';
  final flag = 0;

  late final targetDateTime;
  late final createTime;

  TodoItem({required this.title}) {
    createTime = DateTime.now().millisecondsSinceEpoch;
    targetDateTime = DateTime.now().millisecondsSinceEpoch;
  }

  toMap() {
    return {
      'title': title,
      'createTime': createTime,
      'isDone': isDone,
      'targetDateTime': targetDateTime,
      'deleteTime': deleteTime,
      'content': content,
      'location': location,
      'flag': flag,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

// Open a connection to the database
Future<Database> openDb() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'todo-data.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      // Create a table
      return db.execute(
        sql,
      );
    },
    version: 1,
  );
}

// Insert data
Future<void> insertData(Database db, String name) async {
  await db.insert(
    tableName,
    {'name': name},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Query data
Future<List<Map<String, dynamic>>> queryData(Database db) async {
  return db.query(tableName);
}

// Update data
Future<void> updateData(Database db, int id, String name) async {
  await db.update(
    tableName,
    {'name': name},
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Delete data
Future<void> deleteData(Database db, int id) async {
  await db.delete(
    tableName,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Example usage
Future<void> main() async {
  final db = await openDb();

  await insertData(db, 'Sample Name');
  final queriedData = await queryData(db);
  print(queriedData);

  await updateData(db, 1, 'Updated Name');
  await deleteData(db, 1);

  db.close();
}
