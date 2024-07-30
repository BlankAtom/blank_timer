import 'package:blank_timer/pages/swipe_item.dart';
import 'package:blank_timer/pages/todo.dart';
import 'package:flutter/material.dart';

// TODO 需要绑定一个集合引用，用于显示和修改列表，并作用于存储
class SwipeList extends StatefulWidget {
  final String groupTitle;
  late bool isExpanded = true;
  // final double offset;
  SwipeList({required this.groupTitle});

  @override
  _SwipeListState createState() => _SwipeListState();
}

class _SwipeListState extends State<SwipeList> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  final Color groupHeaderColor = Color.fromARGB(255, 234, 251, 253);

  @override
  Widget build(BuildContext context) {
    // 列表，有表头，使用 SwipItem 作为列表项
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: getListItems(),
      ),
    );
  }

  List<Widget> getListItems() {
    List<Widget> list = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
        child: firstListTile(),
      )
    ];
    if (!widget.isExpanded) {
      return list;
    }

    for (var i = 0; i < items.length; i++) {
      Widget? tile = Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
        child: SwipeItem(
          key: Key(i.toString()),
          child: ListTile(
            title: Text('${items[i]}'),
          ),
        ),
      );

      list.add(tile);
    }
    return list;
  }

  /// 列表试图的第一个元素，也是该组的表头、组名、收放按钮
  /// 颜色适用于第二容器颜色
  Widget firstListTile() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTapUp: (details) {
          setState(() {
            widget.isExpanded = !widget.isExpanded;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: groupHeaderColor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO 添加旋转效果，需要用到 Animate， Trasform
              if(widget.isExpanded)
                Icon(Icons.keyboard_arrow_down_rounded),
              if(!widget.isExpanded) 
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
    );
  }
}
