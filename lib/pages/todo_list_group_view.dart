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

  List<TodoItem> undoItems;

  List<TodoItem> doneItems;

  // final double offset;
  TodoListGroupView({
    super.key,
    required this.groupTitle,
    required this.onItemChange,
    required this.onItemDeleted,
    this.isExpanded = true,
    this.isReverse = false,
    this.doneItems = const [],
    this.undoItems = const [],
  });

  @override
  State<TodoListGroupView> createState() => _TodoListGroupViewState();
}

class _TodoListGroupViewState extends State<TodoListGroupView> {
  final Color groupHeaderColor = Colors.pink[100]!;
  final Color groupDoneHeaderColor = Colors.purple[100]!; 

  final Color _itemForegroundColor = Color.fromRGBO(223, 223, 223, 1);
  final Color _itemDeleteViewColor = Color(Colors.red[400]!.value);
  final Color _itemMoveViewColor = Color(Colors.blue[400]!.value);
  final double _checkBoxWidth = 50;
  final double _itemHeight = 56;
  bool checked = false;
  final BorderRadius _itemCircleRadius = BorderRadius.circular(6);
  @override
  Widget build(BuildContext context) {
    var background = Container(
      decoration: BoxDecoration(
        color: _itemMoveViewColor,
        borderRadius: _itemCircleRadius,
      ),
      child: const Center(
        child: Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
    var secondaryBackground = Container(
      decoration: BoxDecoration(
        color: _itemDeleteViewColor,
        borderRadius: _itemCircleRadius,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete_forever_outlined,
        color: Colors.white60,
      ),
    );

    // 列表，有表头，使用 SwipItem 作为列表项
    var length = widget.undoItems.length +
        widget.doneItems.length +
        (widget.undoItems.isNotEmpty ? 1 : 0) +
        (widget.doneItems.isNotEmpty ? 1 : 0);
    return ListView.builder(
      reverse: true,
      physics: ClampingScrollPhysics(),
      itemCount: length,
      itemBuilder: (context, index) {
        if (index == widget.undoItems.length && widget.undoItems.isNotEmpty) {
          return firstListTile('未完成');
        } else if (index == length - 1 && widget.doneItems.isNotEmpty) {
          return firstListTile('已完成');
        } else if (index < widget.undoItems.length) {
          var item = widget.undoItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
            child: Dismissible(
              key: Key(item.id.toString()),
              background: background,
              secondaryBackground: secondaryBackground,
              onDismissed: (direction) {
                widget.onItemDeleted(item.id);
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return true;
                }
                return false;
              },
              child: SwipeItem(
                child: Text(''),
                todoItem: item,
                onItemDeleted: (key) {
                  widget.onItemDeleted(item.id);
                },
                onItemChange: (key) {
                  widget.onItemChange(item);
                },
                key: Key(item.id.toString()),
              ),
            ),
          );
        } else {
          var i = index - widget.undoItems.length;
          if (widget.undoItems.isNotEmpty && index >= widget.undoItems.length) {
            i -= 1;
          }
          var item = widget.undoItems.isNotEmpty && index < widget.undoItems.length
              ? widget.undoItems[i]
              : widget.doneItems[i];

          debugPrint('index: $index, ${widget.undoItems.length}, ${widget.undoItems.isNotEmpty && i < widget.undoItems.length}');

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
            child: Dismissible(
              key: Key(item.id.toString()),
              background: background,
              secondaryBackground: secondaryBackground,
              onDismissed: (direction) {
                widget.onItemDeleted(item.id);
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return true;
                }
                return false;
              },
              child: SwipeItem(
                child: Text(''),
                todoItem: item,
                onItemDeleted: (key) {
                  widget.onItemDeleted(item.id);
                },
                onItemChange: (key) {
                  widget.onItemChange(item);
                },
                key: Key(item.id.toString()),
              ),
            ),
          );
        }
      },
    );
  }

  // List<Widget> getListItems(List<TodoItem> items) {
  //   return [
  //     for (var item in items)
  //       Padding(
  //         key: GlobalKey(),
  //         padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
  //         child: SwipeItem(
  //           key: Key(item.id.toString()),
  //           child: ListTile(
  //             title: Text('${item.title}'),
  //           ),
  //           todoItem: item,
  //           onItemDeleted: (key) {
  //             setState(() {
  //               widget.onItemDeleted(item.id);
  //               debugPrint(
  //                   'Deleted: $key, ${items.length}, ${widget.undoItems.length}');
  //             });
  //           },
  //         ),
  //       ),
  //     firstListTile(),
  //   ];
  //   // var items = widget.children;
  //   List<Widget> list = [];

  //   if (!widget.isExpanded) {
  //     return list;
  //   }

  //   for (var i = 0; i < items.length; i++) {
  //     var item = items[i];
  //     Widget? tile = Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
  //       child: SwipeItem(
  //         key: Key(i.toString()),
  //         child: ListTile(
  //           title: Text('${item.title}'),
  //         ),
  //         todoItem: item,
  //         onItemDeleted: (key) {
  //           setState(() {
  //             widget.onItemDeleted(item.id);
  //             debugPrint(
  //                 'Deleted: $key, ${list.length}, ${widget.undoItems.length}');
  //           });
  //         },
  //       ),
  //     );

  //     // list.insert(0, tile);
  //     list.add(tile);
  //   }

  //   if (widget.isReverse) {
  //     list.insert(0, firstListTile());
  //   } else {
  //     list.add(firstListTile());
  //   }

  //   return list;
  // }

  /// 列表试图的第一个元素，也是该组的表头、组名、收放按钮
  /// 颜色适用于第二容器颜色
  Widget firstListTile(String title) {
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
                color: title == '已完成' ? groupDoneHeaderColor : groupHeaderColor),
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
                  child: Text(title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
