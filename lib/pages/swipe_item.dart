import 'package:blank_timer/pages/todo.dart';
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

  SwipeItem(
      {required this.key, required this.child});

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
    final Color _itemForegroundColor = Color.fromRGBO(223, 223, 223, 1);
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
        color: _itemForegroundColor,
        borderRadius: _itemCircleRadius,
      ),
      child: Dismissible(
        key: widget.key,

        // Left background
        background: background,

        // Right background
        secondaryBackground: secondaryBackground,

        onDismissed: (direction) {
          debugPrint('删除');
        },

        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            debugPrint('删除 confirmDismiss');
            return true;
          }
          return false;
        },

        child: SizedBox(
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
      ),
    );
  }
}
