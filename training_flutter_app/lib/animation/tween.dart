import 'dart:math' as math show sin, pi;
import 'package:flutter/animation.dart';

/// DelayTween tạo hiệu ứng dao động (wave)
/// với độ trễ pha (delay) cho loading animation
class DelayTween extends Tween<double> {
  /// delay: độ lệch pha (0.0 → 1.0)
  /// mỗi item loading nên có delay khác nhau
  final double delay;

  DelayTween({required double begin, required double end, this.delay = 0.0})
    : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    // Đảm bảo t luôn nằm trong [0, 1]
    final double shiftedT = t - delay;

    // Hàm sin tạo dao động mượt:
    // sin(x) ∈ [-1, 1]
    final double wave = (math.sin(shiftedT * 2 * math.pi) + 1) / 2;

    // Áp wave vào Tween gốc
    return super.lerp(wave.clamp(0.0, 1.0));
  }

  @override
  double evaluate(Animation<double> animation) {
    return lerp(animation.value);
  }
}
