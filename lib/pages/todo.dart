import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoConstraint {
  static const todoNavigationBottoms = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.timer),
      label: 'Timer',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.alarm),
      label: 'Alarm',
    ),
  ];
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late int _pageIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mainBody = SwipeList(
      visible: Text('123'),
      offset: 40,
    );
    // return Container(
    //   child: SwipeItem(
    //     child: const Text('123'),
    //     onButtonTap: () {
    //       debugPrint('删除');
    //     },
    //   ),
    // );
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SwipeItem(
            child: const Text('123'),
            onButtonTap: () {
              debugPrint('删除');
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _pageIndex,
        items: TodoConstraint.todoNavigationBottoms,
      ),
    );
  }
}

/// Item
class SwipeItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onButtonTap;
  SwipeItem({required this.child, required this.onButtonTap});

  @override
  _SwipeItemState createState() => _SwipeItemState();
}

class _SwipeItemState extends State<SwipeItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _withAnimation;
  final double _initialWidth = 500;
  final double _swipedWidth = 450;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _withAnimation = Tween<double>(
      begin: _initialWidth,
      end: _swipedWidth,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.blue.withOpacity(.5),
                          // child: Center(child: widget.child)
                          ),
                      ),
                      // if (_controller.value > 0.5)
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: widget.onButtonTap,
                        )
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: _withAnimation.value,
                      color: Color(Colors.red.value).withOpacity(0.5),
                      child:  Align(
                      alignment: Alignment.centerLeft,
                        child: widget.child),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SwipeList extends StatefulWidget {
  final Widget visible;
  final double offset;
  SwipeList({required this.visible, required this.offset});

  @override
  _SwipeListState createState() => _SwipeListState();
}

class _SwipeListState extends State<SwipeList> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Dismissible(
          // Each Dismissible must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(item),
          // Provide a function that tells the app
          // what to do after an item has been swiped away.
          onDismissed: (direction) {
            // Remove the item from the data source.
            setState(() {
              items.removeAt(index);
            });

            // Then show a snackbar.
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: ListTile(
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
              },
            ),
            title: Text(item),
          ),
        );

        return Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  // ToastUtil.show()
                  debugPrint('删除');
                },
                child: Container(
                  width: 80,
                  height: 200,
                  alignment: Alignment.center,
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),
            Positioned(
              child: widget.visible,
              height: 200,
              left: -widget.offset,
              right: widget.offset,
            )
          ],
        );
      },
    );
  }
}

/*

// List item, when gesture is right to left, it will show delete button
class ListItem extends StatelessWidget {
  final String title;
  final Function onDelete;

  ListItem({this.title, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}*/
