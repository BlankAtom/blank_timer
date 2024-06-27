import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SwipeList(
          visible: Text('123'),
          offset: 40,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarm',
          ),
        ],
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
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$item dismissed')));
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
