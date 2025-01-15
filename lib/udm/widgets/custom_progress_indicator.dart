import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  static int? shorterIndex;

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  bool animateFlag = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      animate();
    });
    super.initState();
  }

  dispose() {
    animateFlag = false;
    super.dispose();
  }

  // Orange .... Teal-ish palette
  final List<GlobalKey<AnimatedBarState>> _keys = [
    GlobalKey<AnimatedBarState>(),
    GlobalKey<AnimatedBarState>(),
    GlobalKey<AnimatedBarState>(),
    GlobalKey<AnimatedBarState>(),
    GlobalKey<AnimatedBarState>(),
  ];

  List<AnimatedBar> get animatedBars => [
    AnimatedBar(const Color(0xffF3722C), key: _keys[0]),
    AnimatedBar(const Color(0xffF8961E), key: _keys[1]),
    AnimatedBar(const Color(0xffF9C74F), key: _keys[2]),
    AnimatedBar(const Color(0xff90BE6D), key: _keys[3]),
    AnimatedBar(const Color(0xff43AA8B), key: _keys[4]),
  ];

  void animate() async {
    int prevOddIndex = -1;
    int oddIndex = 2;
    int evenIndex = 0;
    int prevEvenIndex = -1;
    while (animateFlag) {
      oddIndex += 2;
      oddIndex %= 5;
      evenIndex += 2;
      evenIndex %= 5;
      _keys[oddIndex].currentState?.animate();
      _keys[evenIndex].currentState?.animate();
      if (prevOddIndex >= 0) {
        _keys[prevOddIndex].currentState?.makeNormal();
      }
      if (prevEvenIndex >= 0) {
        _keys[prevEvenIndex].currentState?.makeNormal();
      }
      prevOddIndex = oddIndex;
      prevEvenIndex = evenIndex;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: animatedBars,
      ),
    );
  }
}

class AnimatedBar extends StatefulWidget {
  const AnimatedBar(this._color, {Key? key}) : super(key: key);
  final Color? _color;

  @override
  AnimatedBarState createState() => AnimatedBarState();
}

class AnimatedBarState extends State<AnimatedBar> {
  double _height = 55;
  @override
  initState() {
    super.initState();
  }

  void makeNormal() {
    setState(() {
      _height += 30;
    });
  }

  void animate() {
    setState(() {
      if (_height > 26) _height -= 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      duration: const Duration(milliseconds: 130),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget._color == null ? Colors.black : widget._color,
      ),
      width: 10,
      height: _height,
    );
  }
}