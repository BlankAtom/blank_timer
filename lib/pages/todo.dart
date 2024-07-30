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
      icon: Icon(Icons.alarm),
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

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Widget getSlider() {
    var test1 = SliderContainer();

    var test2 = Dismissible(
      onDismissed: (direction) => debugPrint('删除'),
      key: Key('1'),
      child: Slidable(
        key: Key(1.toString()),
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // 处理编辑事件
                debugPrint('编辑');
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: '编辑',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // 处理删除事件
                debugPrint('删除');
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
            ),
          ],
        ),
        child: Container(
          // width: 300,
          color: Colors.yellow,
          child: ListTile(
            title: Text('Item 1'),
          ),
        ),
      ),
    );

    return test2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SwipeList(
        groupTitle: 'Done',
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: TodoConstraint.todoNavigationBottoms,
        currentIndex: _pageIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
