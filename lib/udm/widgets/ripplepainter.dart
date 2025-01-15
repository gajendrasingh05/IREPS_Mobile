
import 'package:flutter/material.dart';

class RipplePainter extends CustomPainter {
  final Offset? center;
  final double? radius, containerHeight;
  final BuildContext context;

   Color? color;
  double? statusBarHeight, screenWidth;

  RipplePainter({this.center, this.radius, this.containerHeight, required this.context, this.color, this.screenWidth, this.statusBarHeight}){
     ThemeData theme = Theme.of(context);

    color = Colors.red[200];
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }
   @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();
    

    circlePainter.color = color!;
    canvas.clipRect(Rect.fromLTWH(0, 0, screenWidth!, containerHeight! + statusBarHeight!));
    canvas.drawCircle(center!, radius!, circlePainter);
  }
   @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}