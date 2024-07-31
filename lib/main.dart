import 'dart:async';
import 'dart:io';

import 'package:blank_timer/pages/todo.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pages/converter.dart';

void main() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } 
  runApp(const MyApp());
}

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
      home: TodoPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _currentIndex++;
    });
  }

  final List<Widget> _children = [
    MyTimerViewWidget(),
    TimerActive(
      scale: 10 * 1000,
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
        title: Text(widget.title),
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
      body: _children[_currentIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyTimerViewWidget extends StatelessWidget {
  const MyTimerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TimerItem(),
              TimerItem(),
              TimerItem(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerItem extends StatefulWidget {
  const TimerItem({super.key});

  @override
  State<TimerItem> createState() => _TimerItemState();
}

class _TimerItemState extends State<TimerItem> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {});
    });
  }

  void stopStopwatch() {
    _stopwatch.stop();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime =
        '${_stopwatch.elapsed.inMinutes}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}.${(_stopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}';
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              elapsedTime,
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: startStopwatch,
                  child: Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: stopStopwatch,
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

/// 计时器展开组件
class TimerActive extends StatefulWidget {
  /// 尺度，用于控制计时的中间尺度 X
  int scale;

  TimerActive({super.key, required this.scale});

  @override
  State<TimerActive> createState() => _TimerActiveState();
}

class _TimerActiveState extends State<TimerActive> {
  late String _label;
  late bool _isRunning;
  late Stopwatch _stopwatch;
  late Timer _timer;
  late int _startTime_A;
  late int _nowTime_T;
  late int _flowstamp;
  late int _lastFlowStamp;
  late int _lastTimestamp;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _isRunning = false;
    _startTime_A = 0;
    _flowstamp = 0;
    _lastFlowStamp = 0;
    _lastTimestamp = 0;
    lastRatio = 0;
    ratio = 0;
  }

  void startStopwatch() {
    _stopwatch.start();
    _startTime_A = _lastTimestamp = DateTime.now().millisecondsSinceEpoch;

    // 100 毫秒运行一次，更新 当前时间 T
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _nowTime_T = DateTime.now().millisecondsSinceEpoch;
      int delta = _nowTime_T - _lastTimestamp;
      setState(() {
        _lastFlowStamp = _flowstamp + delta;
      });
    });
  }

  void stopStopwatch() {
    _flowstamp = _lastFlowStamp;
    _stopwatch.stop();
    _timer.cancel();
  }

  void longPress() {
    print("Done");
  }

  void onTapbar() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        startStopwatch();
      } else {
        stopStopwatch();
      }
    });
  }

  String getTimeString() {
    /**
     * 需要指出的是，在计时器展开后，应该先倒计时，再正着计时。
     * 这里要涉及的一个中间量。
     * 也就是 中间量X, 另外设 开始计时的时间为 A，
     * 倒计时尺度为 X，结束计时的时间为 R，此时为 T，
     * 暂停的时间长度为 P
     * 那么，任一时间的表示S可以用表达式得到：
     * R = S = X - (T - P - A)
     * 由于 Stopwatch计时，有经过的时间长度B，所以S又可以表示为
     * S = B - X
     */
    var duration = (_stopwatch.elapsed - Duration(milliseconds: widget.scale)).abs();

    return '${duration.inHours.toString().padLeft(2, '0')}'
        ':${duration.inMinutes.toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double getTimeRatio() {
    return _stopwatch.elapsedMilliseconds * 1.0 / widget.scale;
  }

  late double lastRatio;
  late double ratio;

  @override
  Widget build(BuildContext context) {
    final elapsedTime =
        '${_stopwatch.elapsed.inMinutes}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}.${(_stopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}';
    var duration = Duration(milliseconds: _lastFlowStamp);
    // final timeString =
    //     '${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    var str = getTimeString();
    // TODO ratio 的更新没有使得progress更新，需要传入一个回调
    setState(() {
      lastRatio = ratio;
      ratio = getTimeRatio();
      if (ratio > 1) ratio = 1;
    });
    // print(str);
    // print(_lastFlowStamp);
    return GestureDetector(
      onTap: onTapbar,
      onLongPress: longPress,
      // onSecondaryLongPress: () => {print("Long Press")},
      child: Container(
        child: CircleProgressBar(
          lastProgress: lastRatio,
          progress: ratio,
          isRunning: _isRunning,
          label: str,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CircleProgressBar extends StatelessWidget {
  final double progress;
  final double lastProgress;
  final String label;
  final bool isRunning;

  CircleProgressBar({required this.progress, required this.isRunning, required this.label, required this.lastProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 8,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: AnimatedCircle(
        progress: progress,
        lastProgress: lastProgress,
        // foregroundPainter: CircleProgressPainter(progress: progress),
        child: SizedBox(
          height: 200,
          child: Center(
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(isRunning ? "Pause" : "Start"),
                  Text(label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  final double progress;
  final double lastProgress;
  final Widget child;

  AnimatedCircle({required this.progress, required this.child, required this.lastProgress});
  @override
  _AnimatedCircleState createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double _pro;
  @override
  void initState() {
    super.initState();
    _pro = 0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );

    print('last: ${widget.lastProgress}, now: ${widget.progress}');
    _animation = Tween<double>(begin: widget.lastProgress, end: widget.progress).animate(_controller)
      ..addListener(() {
        setState(() {
          _pro = _animation.value;
        });
      });

    _controller.forward();
    // _animation.
  }

  @override
  Widget build(BuildContext context) {
    // _controller.forward();
    print('Animator circle: ${_pro}');
    return CustomPaint(
      foregroundPainter: CircleProgressPainter(progress: _pro),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;

  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    Paint progressPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double progressAngle = 2 * progress * 3.1415;

    canvas.drawArc(
      Offset.zero & size,
      -3.1415 / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
