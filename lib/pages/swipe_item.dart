import 'package:blank_timer/pages/todo.dart';
import 'package:blank_timer/todo_data.dart';
import 'package:flutter/material.dart';

/// Item of SwipeList
/// Need structure like this:
/// ```
/// Item:
///   - Title
///   - Checked
///   - Group
///   - Time
/// ```
class SwipeItem extends StatefulWidget {
  final Widget child;

  final Key key;

  final ValueChanged<TodoItem> onItemDeleted;

  final TodoItem todoItem;

  final ValueChanged<TodoItem> onItemChange;

  SwipeItem(
      {required this.key,
      required this.child,
      required this.onItemDeleted,
      required this.todoItem,
      required this.onItemChange});

  @override
  _SwipeItemState createState() => _SwipeItemState();
}

class _SwipeItemState extends State<SwipeItem> {
  final double _checkBoxWidth = 50;
  final double _itemHeight = 56;
  final BorderRadius _itemCircleRadius = BorderRadius.circular(6);

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final Color _itemForegroundColor = Colors.pink[50]!;
    final Color _itemDoneForegroundColor = Colors.grey;
    final Color _itemDeleteViewColor = Color(Colors.red[400]!.value);
    final Color _itemMoveViewColor = Color(Colors.blue[400]!.value);

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

    return Container(
      decoration: BoxDecoration(
        color: widget.todoItem.isDone == 1 ? _itemDoneForegroundColor : _itemForegroundColor,
        borderRadius: _itemCircleRadius,
      ),
      height: _itemHeight,
      child: Row(
        children: [
          SizedBox(
            width: _checkBoxWidth,
            child: Checkbox(
              onChanged: (v) {
                setState(() {
                  checked = v!;
                  widget.todoItem.isDone = checked ? 1 : 0;
                  widget.onItemChange(widget.todoItem);
                });
              },
              value: widget.todoItem.isDone == 1,
              shape: const CircleBorder(),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                widget.todoItem.title,
                style: TextStyle(
                    decoration: widget.todoItem.isDone == 1
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ),
        ],
      ),
    );
    Dismissible(
      key: widget.key,
      background: background,
      secondaryBackground: secondaryBackground,
      onDismissed: (direction) {
        widget.onItemDeleted(widget.todoItem);
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return true;
        }
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          color: _itemForegroundColor,
          borderRadius: _itemCircleRadius,
        ),
        height: _itemHeight,
        child: Row(
          children: [
            SizedBox(
              width: _checkBoxWidth,

              // The Selecter box
              child: Checkbox(
                onChanged: (v) {
                  setState(() {
                    checked = v!;
                  });
                },
                value: checked,
                shape: const CircleBorder(),
              ),
            ),
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
