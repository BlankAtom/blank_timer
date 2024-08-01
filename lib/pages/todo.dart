import 'package:blank_timer/event_bus.dart';
import 'package:blank_timer/todo_data.dart';
import 'package:blank_timer/widgets/slider_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'todo_list_group_view.dart';

// class TodoConstraint {
//   static const todoNavigationBottoms = <BottomNavigationBarItem>[
//     BottomNavigationBarItem(
//       icon: Icon(Icons.timer),
//       label: 'Timer',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.today_rounded),
//       label: 'Today',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.sunny),
//       label: 'Alarm',
//     ),
//   ];

//   // static const
// }

// class TodayTodoPage extends StatelessWidget {

//   TodayTodoPage({Key? key}) : super(key: key){
//     bus.on("todoUpdated", (arg) {
//       // do something
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class TodayTodoPage extends StatefulWidget {
  @override
  _TodayTodoPageState createState() => _TodayTodoPageState();
}

/// 今日待办页面
/// Data：今日待办数据
/// Where：
class _TodayTodoPageState extends State<TodayTodoPage> {
  late int _pageIndex = 1;
  late ToDoProvider _todoProvider;

  _TodayTodoPageState() {
    _todoProvider = ToDoProvider();
  }

  List<TodoItem> items = [];

  @override
  void initState() {
    super.initState();

    bus.on("todoUpdated", (arg) {
      _todoProvider.queryData().then((value) {
        setState(() {
          items = value;
        });

        debugPrint('Todo updated');
      });
    });

    _todoProvider.openDb().then((value) {
      _todoProvider.queryData().then((value) {
        setState(() {
          items = value;
        });
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  // Future<List<TodoItem>> getItems() async {
  //   await _todoProvider.openDb();
  //   return _todoProvider.queryData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 720, // Set the maximum width here
          ),
        
          alignment: Alignment.topCenter,
          
          child: Column(
            children: [
              Expanded(
                child: TodoListGroupView(
                  groupTitle: '未完成',
                  // provider: _todoProvider,
                  children: items,
                  onItemChange: (item) {
                    // item.status = 2;
                    // item.updatedAt = DateTime.now().millisecondsSinceEpoch;
                    _todoProvider.updateData(item);
                    bus.emit("todoUpdated");
                  },
                  onItemDeleted: (id) {
                    debugPrint('Deleted: $id');
                    _todoProvider.deleteDataById(id);
                    bus.emit("todoUpdated");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TodoAddBox(onAdded: (value) {
                  _todoProvider.insertData(value);
                  bus.emit("todoUpdated");
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoAddBox extends StatefulWidget {
  final ValueChanged<TodoItem> onAdded;

  const TodoAddBox({super.key, required this.onAdded});

  @override
  _TodoAddBoxState createState() => _TodoAddBoxState();
}

class _TodoAddBoxState extends State<TodoAddBox> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller!.addListener(() {
      print('Controller: ${_controller!.text}');
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Container(
        child: Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Expanded(
              // padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    TodoItem item = TodoItem(
        0,
        text,
        1,
        DateTime.now().millisecondsSinceEpoch,
        '',
        '',
        0,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch);

    setState(() {
      widget.onAdded(item);
      _controller!.clear();
    });
  }
}
