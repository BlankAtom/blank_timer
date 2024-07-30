import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SliderContainer extends StatefulWidget {
  @override
  _SliderContainerState createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  double _position = 0.0;

  @override
  Widget build(BuildContext context) {
    // RawGestureDetector()

    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          _position += details.delta.dx;
        });
      },
      child: PageView(
        
        children: [
          Container(
            width: 400,
            height: 200.0,
            color: Colors.blue,
            alignment: Alignment.center,
            // transform: Matrix4.translationValues(_position, 0.0, 0.0),
            child: Container(
              child: const Text(
                'Drag me!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              print('Pressed');
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
