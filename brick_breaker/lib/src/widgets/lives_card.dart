import 'package:flutter/material.dart';

class LivesCard extends StatefulWidget {
  const LivesCard({super.key, required this.lives});

  final ValueNotifier<int> lives;

  @override
  State<LivesCard> createState() => _LivesCardState();
}

class _LivesCardState extends State<LivesCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _prevLives;

  @override
  void initState() {
    super.initState();
    _prevLives = widget.lives.value;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    widget.lives.addListener(_onLivesChanged);
  }

  void _onLivesChanged() {
    if (widget.lives.value < _prevLives) {
      _controller.forward(from: 0); // ❤️ animate khi mất mạng
    }
    _prevLives = widget.lives.value;
  }

  @override
  void dispose() {
    widget.lives.removeListener(_onLivesChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge!;

    return ValueListenableBuilder<int>(
      valueListenable: widget.lives,
      builder: (context, lives, _) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = 1 + (1 - _controller.value) * 0.4;

            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: RichText(
            text: TextSpan(
              style: style,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Opacity(
                      opacity: 0.6 + 0.4 * (1 - _controller.value),
                      child: Icon(
                        Icons.favorite,
                        color: lives <= 1
                            ? Colors.deepOrange
                            : Colors.redAccent,
                        size: style.fontSize! * 1.1,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: 'x$lives'),
              ],
            ),
          ),
        );
      },
    );
  }
}

