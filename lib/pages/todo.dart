import 'package:blank_timer/todo_data.dart';
import 'package:blank_timer/widgets/slider_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'swipe_list.dart';

class TodoConstraint {
  static const todoNavigationBottoms = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.timer),
      label: 'Timer',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.today_rounded),
      label: 'Today',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sunny),
      label: 'Alarm',
    ),
  ];

  // static const
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late int _pageIndex = 1;
  late ToDoProvider _todoProvider;

  _TodoPageState(){
    _todoProvider = ToDoProvider();
  }

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Future<List<TodoItem>> getItems() async {
    await _todoProvider.openDb();
    return _todoProvider.queryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: FutureBuilder(
        
          future: _todoProvider.openDb(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: SwipeList(
                      groupTitle: 'Done',
                      provider: _todoProvider,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TodoAddBox(onAdded: (value) {
                      _todoProvider.insertData(value);
                    }),
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: TodoConstraint.todoNavigationBottoms,
        currentIndex: _pageIndex,
        onTap: onTabTapped,
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
    TodoItem item = TodoItem(0, text, 1, DateTime.now().millisecondsSinceEpoch, '', '', 0, DateTime.now().millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch);

    setState(() {
      
        widget.onAdded(item);
        _controller!.clear();
    });
  }
}
