import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:training_flutter_app/animation/tween.dart';

enum SpinKitShape { circle, square }

class SpinKitFadingCircle extends StatefulWidget {
  const SpinKitFadingCircle({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
    this.shape = SpinKitShape.circle, // 👈 default
  }) : assert(
         (itemBuilder != null) ^ (color != null),
         'Provide either itemBuilder or color',
       );

  final Color? color; //màu mặc định cho dot
  final double size; //kích thước toàn spinner
  final IndexedWidgetBuilder? itemBuilder; //cho phép custom mỗi dot
  final Duration duration; //thời gian 1 vòng
  final AnimationController? controller; //cho phép truyền controller từ ngoài
  final SpinKitShape shape;

  @override
  State<SpinKitFadingCircle> createState() => _SpinKitFadingCircleState();
}

class _SpinKitFadingCircleState extends State<SpinKitFadingCircle>
    with SingleTickerProviderStateMixin {
  static const int _dotCount = 12;

  late final AnimationController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
              AnimationController(vsync: this, duration: widget.duration)
          ..repeat();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(children: List.generate(_dotCount, (i) => _buildDot(i))),
    );
  }

  Widget _buildDot(int index) {
    final dotSize = widget.size * 0.15;
    final angle = (2 * math.pi / _dotCount) * index;
    final delay = -index / _dotCount;

    return Center(
      child: Transform.rotate(
        angle: angle,
        child: Align(
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: DelayTween(
              begin: 0.0,
              end: 1.0,
              delay: delay,
            ).animate(_controller),
            child: SizedBox.square(
              dimension: dotSize,
              child: _buildItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, index);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.color,
        shape: widget.shape == SpinKitShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: widget.shape == SpinKitShape.square
            ? BorderRadius.circular(4)
            : null,
      ),
    );
  }
}
