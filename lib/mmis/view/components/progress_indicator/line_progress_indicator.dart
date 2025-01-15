//import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ArcType { HALF, FULL, FULL_REVERSED }

enum CircularStrokeCap { butt, round, square }

extension CircularStrokeCapExtension on CircularStrokeCap {
  StrokeCap get strokeCap {
    switch (this) {
      case CircularStrokeCap.butt:
        return StrokeCap.butt;
      case CircularStrokeCap.round:
        return StrokeCap.round;
      case CircularStrokeCap.square:
        return StrokeCap.square;
    }
  }
}

num radians(num deg) => deg * (math.pi / 180.0);

class LineProgressIndicator extends StatefulWidget {
  final double percent;
  final double width;
  final double height;
  final double lineWidth;
  final Color fillColor;
  final Color backgroundColor;
  Color get progressColor => _progressColor;
  late Color _progressColor;
  final bool animation;
  final int animationDuration;
  final Widget? header;
  final Widget? footer;
  final Widget? center;
  final LinearGradient? linearGradient;
  final CircularStrokeCap circularStrokeCap;
  final double startAngle;
  final bool animateFromLastPercent;
  final bool addAutomaticKeepAlive;
  final Color? arcBackgroundColor;
  final bool reverse;
  final MaskFilter? maskFilter;
  final Curve curve;
  final bool restartAnimation;
  final VoidCallback? onAnimationEnd;
  final Widget? widgetIndicator;
  final bool rotateLinearGradient;

  LineProgressIndicator({
    Key? key,
    this.percent = 0.0,
    this.width = 200.0,
    this.height = 10.0,
    this.lineWidth = 5.0,
    this.fillColor = Colors.transparent,
    this.backgroundColor = const Color(0xFFB8C7CB),
    Color? progressColor,
    this.animation = false,
    this.animationDuration = 500,
    this.header,
    this.footer,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.circularStrokeCap = CircularStrokeCap.butt,
    this.arcBackgroundColor,
    this.animateFromLastPercent = false,
    this.reverse = false,
    this.curve = Curves.linear,
    this.maskFilter,
    this.restartAnimation = false,
    this.onAnimationEnd,
    this.widgetIndicator,
    this.rotateLinearGradient = false, this.linearGradient, required this.startAngle,
  }) : super(key: key) {
    _progressColor = progressColor ?? Colors.red;

    assert(startAngle >= 0.0);
    if (percent < 0.0 || percent > 1.0) {
      throw Exception("Percent value must be a double between 0.0 and 1.0, but it's $percent");
    }
  }

  @override
  _LineProgressIndicatorState createState() =>
      _LineProgressIndicatorState();
}

class _LineProgressIndicatorState extends State<LineProgressIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  Animation? _animation;
  double _percent = 0.0;

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.animation) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration),
      );
      _animation = Tween(begin: 0.0, end: widget.percent).animate(
        CurvedAnimation(parent: _animationController!, curve: widget.curve),
      )..addListener(() {
        setState(() {
          _percent = _animation!.value;
        });
        if (widget.restartAnimation && _percent == 1.0) {
          _animationController!.repeat(min: 0, max: 1.0);
        }
      });
      _animationController!.addStatusListener((status) {
        if (widget.onAnimationEnd != null &&
            status == AnimationStatus.completed) {
          widget.onAnimationEnd!();
        }
      });
      _animationController!.forward();
    } else {
      _updateProgress();
    }
    super.initState();
  }

  void _updateProgress() {
    setState(() => _percent = widget.percent);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomPaint(
      painter: _LinePainter(
        progress: _percent,
        progressColor: widget.progressColor,
        backgroundColor: widget.backgroundColor,
        lineWidth: widget.height,
        backgroundWidth: widget.height,
        arcBackgroundColor: widget.arcBackgroundColor,
        reverse: widget.reverse,
        linearGradient: widget.linearGradient,
        maskFilter: widget.maskFilter,
      ),
      child: (widget.center != null)
          ? Center(child: widget.center)
          : SizedBox.expand(),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}

class _LinePainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineWidth;
  final double backgroundWidth;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final Color? arcBackgroundColor;
  final bool reverse;
  final LinearGradient? linearGradient;
  final MaskFilter? maskFilter;

  _LinePainter({
    required this.lineWidth,
    required this.backgroundWidth,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.arcBackgroundColor,
    required this.reverse,
    this.linearGradient,
    this.maskFilter,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = backgroundWidth;

    if (arcBackgroundColor != null) {
      _paintLine.color = arcBackgroundColor!;
    } else {
      _paintLine.color = progressColor;
    }

    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (maskFilter != null) {
      _paintLine.maskFilter = maskFilter;
    }

    if (linearGradient != null) {
      _paintLine.shader = linearGradient!.createShader(
        Rect.fromCircle(center: center, radius: size.width / 2),
      );
    }

    if (reverse) {
      final start = Offset(size.width / 2, size.height / 2);
      final end = Offset(size.width / 2, size.height / 2 - size.height * progress);
      canvas.drawLine(start, end, _paintLine);
      canvas.drawCircle(center, size.width / 2, _paintBackground);
    } else {
      final start = Offset(size.width / 2, size.height / 2);
      final end = Offset(size.width / 2, size.height / 2 + size.height * progress);
      canvas.drawLine(start, end, _paintLine);
      canvas.drawCircle(center, size.width / 2, _paintBackground);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

