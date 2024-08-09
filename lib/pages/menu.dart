import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuExamplePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum MenuEntry {
  about('About'),
  showMessage('Show Message'),
  hideMessage('Hide Message'),
  colorMenu('Color Menu'),
  colorRed('Red Background'),
  colorGreen('Green Background'),
  colorBlue('Blue Background');

  final String label;
  const MenuEntry(this.label);
}

class MenuExamplePage extends StatefulWidget {
  const MenuExamplePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MenuExamplePage> createState() => _MenuExamplePageState();
}

class _MenuExamplePageState extends State<MenuExamplePage> {
  int _counter = 0;
  MenuEntry? _lastSelection;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // MenuEntry? _lastSelection;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor = Colors.red;
  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      setState(() {
        _backgroundColor = value;
      });
    }
  }

  bool get showingMessage => _showingMessage;
  bool _showingMessage = false;
  set showingMessage(bool value) {
    if (_showingMessage != value) {
      setState(() {
        _showingMessage = value;
      });
    }
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Builder(builder: (context) {
          return Row(
            children: [
              headerTextMenu(
                const Text('About'),
                () => Scaffold.of(context).openDrawer(),
              )
            ],
          );
        }),
        actions: [
          // headerTextMenu(const Text('About')),
        ],
        leading: FlutterLogo(),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // borderRadius: BorderRadius.circular(10),
              ),
              height: 200,
            ),
            Expanded(
                child: Container(
                    // child:
                    )),
          ],
        ),
      ),

      drawer: Drawer(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),

        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget headerTextMenu(Widget centerChild, void Function() param1) {
    return HeaderTextPopupMenu(
      centerChild: centerChild,
      menuChildren: _meunList(),
      pressed: param1,
    );
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: _meunList(),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return TextButton(
          style: TextButton.styleFrom(
              //  Theme.of(context).colorScheme.onSurface,
              ),
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: centerChild,
        );
      },
    );
  }

  // https://juejin.cn/post/7194705921128267813#heading-2
  List<Widget> _meunList() {
    return <Widget>[
      MenuItemButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(MenuEntry.about.label),
        ),
        onPressed: () => _activate(MenuEntry.about),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: MenuItemButton(
            child: Text(MenuEntry.about.label),
            onPressed: () => _activate(MenuEntry.about),
          ),
        ),
      ),
    ];
  }

  void _activate(MenuEntry selection) {
    setState(() {
      _lastSelection = selection;
    });

    switch (selection) {
      case MenuEntry.about:
        showAboutDialog(
          context: context,
          applicationName: 'MenuBar Sample',
          applicationVersion: '1.0.0',
        );
        break;
      case MenuEntry.hideMessage:
      case MenuEntry.showMessage:
        showingMessage = !showingMessage;
        break;
      case MenuEntry.colorMenu:
        break;
      case MenuEntry.colorRed:
        backgroundColor = Colors.red;
        break;
      case MenuEntry.colorGreen:
        backgroundColor = Colors.green;
        break;
      case MenuEntry.colorBlue:
        backgroundColor = Colors.blue;
        break;
    }
  }

  List<DropdownMenuItem<dynamic>> get getDropdown {
    return const [
      DropdownMenuItem(
        key: Key('Item 1'),
        child: Text('Item 1'),
        value: 'Item 1',
      ),
      DropdownMenuItem(
        key: Key('Item 2'),
        child: Text('Item 2'),
        value: 'Item 2',
      ),
    ];
  }
}

class HeaderTextPopupMenu extends StatefulWidget {
  HeaderTextPopupMenu({
    required this.centerChild,
    required this.menuChildren,
    required this.pressed,
  }) {}

  final Widget centerChild;
  final List<Widget> menuChildren;
  final Function() pressed;

  @override
  State<StatefulWidget> createState() => _HeaderTextPopupMenuState();
}

class _HeaderTextPopupMenuState extends State<HeaderTextPopupMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late MenuController _menuController;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode(debugLabel: 'Menu Button');
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 100),
    );
    // _animationController.addStatusListener(_onStatusChanged);

    _menuController = MenuController();
    // _menuController.
    // _menuController.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      if (_menuController.isOpen) {
        // _menuController.close();
        _animationController.reverse();
      } else {
        // _menuController.open();
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          onHover: (value) {
            debugPrint('Hover: $value');
            if (!_menuController.isOpen) {
              _menuController.close();
              _animationController.reverse();
            } 
          },
          child: MenuAnchor(
            menuChildren: List.from(widget.menuChildren),
            
            controller: _menuController,
            alignmentOffset: Offset(0, 32),
            childFocusNode: _focusNode,
          ),
        ),
        TextButton(
          onPressed: () {
            if (_menuController.isOpen) {
              _menuController.close();
              _animationController.reverse();
            } else {
              _menuController.open();
              _animationController.forward();
            }
          },
          onHover: (value) {
            _focusNode.requestFocus();
            if (value) {
              _menuController.open();
              // widget.pressed();
              _animationController.forward();
            } else {
              // _menuController.close();
              // _animationController.reverse();
            }
          },
          onFocusChange: (value) => debugPrint('Focus: $value'),
          child: Row(
            children: [
              widget.centerChild,
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 1 * 3.1415926,
                    child: Icon(Icons.arrow_drop_down),
                  );
                },
              )
            ],
          ),
        ),
        
      ],
    );
  }
}
