// 从云端同步数据到本地

// 仅用本地数据
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// 数据表名
const tableTodo = 'TodoItem';

// 数据表创建SQL
const sql = '''
CREATE TABLE $tableTodo (
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

// @JsonCodable() // Macro annotation  But what is Macro?
class TodoItem {
  final int id;

  String title;
  int isDone;
  int deleteTime;
  String content;
  String location;
  int flag;

  int targetDateTime;
  int createTime;

  bool isToday(){
    var now = DateTime.now();
    var target = DateTime.fromMillisecondsSinceEpoch(targetDateTime);
    return now.year == target.year && now.month == target.month && now.day == target.day;
  }

  // TodoItem(
  //     {this.title,
  //     this.isDone = 0,
  //     this.deleteTime = 0,
  //     this.content = '',
  //     this.location = '',
  //     this.flag = 0}) {
  //   createTime = DateTime.now().millisecondsSinceEpoch;
  //   targetDateTime = DateTime.now().millisecondsSinceEpoch;
  // }
  TodoItem(
    this.id,
    this.title,
    this.isDone,
    this.deleteTime,
    this.content,
    this.location,
    this.flag,
    this.targetDateTime,
    this.createTime,
  );

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

  static fromMap(Map<String, dynamic> map) {
    return TodoItem(
      map['id'],
      map['title'],
      map['isDone'],
      map['deleteTime'],
      map['content'],
      map['location'],
      map['flag'],
      map['targetDateTime'],
      map['createTime'],
    );
  }

  static TodoItem fromJson(Map<String, dynamic> json) => fromMap(json);
}

/// TodoProvider To Do 数据提供者
class ToDoProvider {
  /// Database of To do data.
  late Database? db;

  // bool get isOpened => db != null && db!.isOpen;

  /// Open a connection to the database
  Future<void> openDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todo-data.db');

    // if (db != null && db!.isOpen) {
    //   return;
    // }

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create a table
        await db.execute(
          sql,
        );
      },
    );

    refreshCache();
  }

  refreshCache() {
    // queryData().then((value) {
    //   _todoList = value;
    // });
  }

  /// Insert data
  Future<void> insertData(TodoItem todo) async {
    await db?.insert(
      tableTodo,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  
    refreshCache();
  }

  /// Query data of all
  Future<List<TodoItem>> queryData() async {
    var maps = await db?.query(tableTodo);
    if(maps == null || maps.isEmpty){
      return [];
    }

    return [
      for (var map in maps) TodoItem.fromJson(map)
    ];
  }

  /// Query data by id
  Future<TodoItem?> queryDataById(int id) async {
    var list = await db?.query(tableTodo, where: 'id = ?', whereArgs: [id]);
    if(list != null && list.isNotEmpty){
      return TodoItem.fromJson(list[0]);
    }
    return null;
  }

  /// Update data
  Future<void> updateData(TodoItem todo) async {
    await db?.update(
      tableTodo,
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  /// Delete data
  Future<void> deleteData(TodoItem todo) async {
    await db?.delete(
      tableTodo,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
  /// Delete data
  Future<void> deleteDataById(int id) async {
    await db?.delete(
      tableTodo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeAsync() async {
    await db?.close();
  }
}



// // Example usage
// Future<void> main() async {
//   final db = await openDb();

//   await insertData(db, 'Sample Name');
//   final queriedData = await queryData(db);
//   print(queriedData);

//   await updateData(db, 1, 'Updated Name');
//   await deleteData(db, 1);

//   db.close();
// }


// class TodoDataTest {
//   TodoDataTest(){
    
//   }
// }