import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const Icon _addIcon = Icon(Icons.add);

const double _maxInputWidth = 300;
const double _maxInputHeight = 56;

const String _strAddNewItem = 'Add new item';

class InputTile extends StatefulWidget {
  bool _isClicked = false;
  @override
  _InputTileState createState() => _InputTileState();
}

class _InputTileState extends State<InputTile> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        widget._isClicked = _focusNode.hasFocus;
      });
    });
    // _focusNode.fo
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  double dpToPx(BuildContext context, double dp) {
    return dp * MediaQuery.of(context).devicePixelRatio;
  }

  double logicalPixelToPt(BuildContext context, double logicalPixel) {
    // 获取设备的 DPI
    double dpi = MediaQuery.of(context).devicePixelRatio * 160;
    // 1 pt = 1/72 inch
    return logicalPixel / (dpi / 72.0);
  }

  double ptToLogicalPixel(BuildContext context, double pt) {
    // 获取设备的 DPI
    double dpi = MediaQuery.of(context).devicePixelRatio * 160;
    // 1 pt = 1/72 inch
    return pt * 72 * dpi;
  }

  @override
  Widget build(BuildContext context) {
    var dp8 = dpToPx(context, 8.0);
    var dp12 = dpToPx(context, 12.0);
    var dp24 = dpToPx(context, 24.0);
    var dp16 = dpToPx(context, 16.0);
    var dp56 = dpToPx(context, 56.0);

    var pt16 = logicalPixelToPt(context, 16.0);

    const textStyle = TextStyle(fontSize: 16);
    // var sizedBox =

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        if (!widget._isClicked) {
          setState(() {
            widget._isClicked = true;
            _focusNode.requestFocus();
          });
        }
        // FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dp12),
        child: SizedBox(
          width: _maxInputWidth,
          height: dp56,
          child: TextField(
            focusNode: _focusNode,
            onTapOutside: (_) {
              setState(() {
                widget._isClicked = false;
              });
              _focusNode.unfocus();
            },
            canRequestFocus: true,
            controller: _textEditingController,
            // textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,

            style: textStyle,

            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: dp16, top: dp16, bottom: dp16),
                child: !widget._isClicked
                    ? Icon(Icons.add, size: dp24)
                    : Icon(Icons.circle_outlined, size: dp24),
              ),
              hintText: widget._isClicked ? '' : 'Add new item',
            ),
            // contentPadding: EdgeInsets.symmetric(vertical: dp8),
          ),
        ),
      ),
    );
  }
}
