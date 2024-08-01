import 'package:blank_timer/pages/swipe_item.dart';
import 'package:blank_timer/pages/todo.dart';
import 'package:blank_timer/todo_data.dart';
import 'package:flutter/material.dart';

// TODO 需要绑定一个集合引用，用于显示和修改列表，并作用于存储
class TodoListGroupView extends StatefulWidget {
  final String groupTitle;
  // final List<TodoItem> children;
  late bool isExpanded = true;
  late bool isReverse = false;
  late int maxWidth = 0;

  // final ToDoProvider provider;
  final ValueChanged<TodoItem> onItemChange;
  final ValueChanged<int> onItemDeleted;

  var children = List<TodoItem>.empty();

  // final double offset;
  TodoListGroupView(
      {super.key,
      required this.groupTitle,
      required this.onItemChange,
      required this.onItemDeleted,
      required this.children,
      this.isExpanded = true,
      this.isReverse = false});

  @override
  State<TodoListGroupView> createState() => _TodoListGroupViewState();
}

class _TodoListGroupViewState extends State<TodoListGroupView> {
  final Color groupHeaderColor = Color.fromARGB(255, 234, 251, 253);

  @override
  Widget build(BuildContext context) {
    // 列表，有表头，使用 SwipItem 作为列表项
    return ListView(
      reverse: true,
      physics: ClampingScrollPhysics(),
      children: getListItems(),
    );
  }

  List<Widget> getListItems() {
    var items = widget.children;
    List<Widget> list = [];

    if (!widget.isExpanded) {
      return list;
    }

    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      Widget? tile = Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
        child: SwipeItem(
          key: Key(i.toString()),
          child: ListTile(
            title: Text('${item.title}'),
          ),
          todoItem: item,
          onItemDeleted: (key) {
            setState(() {
              widget.onItemDeleted(item.id);
              debugPrint('Deleted: $key');
            });
          },
        ),
      );

      // list.insert(0, tile);
      list.add(tile);
    }

    if (widget.isReverse) {
      list.insert(0, firstListTile());
    } else {
      list.add(firstListTile());
    }

    return list;
  }

  /// 列表试图的第一个元素，也是该组的表头、组名、收放按钮
  /// 颜色适用于第二容器颜色
  Widget firstListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTapUp: (details) {
            setState(() {
              widget.isExpanded = !widget.isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: groupHeaderColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO 添加旋转效果，需要用到 Animate， Trasform
                if (widget.isExpanded) Icon(Icons.keyboard_arrow_down_rounded),
                if (!widget.isExpanded)
                  Icon(Icons.keyboard_arrow_right_rounded),

                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
                  child: Text(widget.groupTitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
