import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, paused, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapCallbacks {
  BrickBreaker()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> lives = ValueNotifier(3);

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState state) {
    _playState = state;

    switch (state) {
      case PlayState.playing:
        resumeEngine();
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        overlays.remove(PlayState.paused.name);
        break;

      case PlayState.paused:
        pauseEngine();
        overlays.add(PlayState.paused.name);
        break;

      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        pauseEngine();
        overlays.add(state.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    if (playState == PlayState.paused) {
      playState = PlayState.playing;
      return;
    }

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;
    lives.value = 3;

    world.add(
      Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2(
          (rand.nextDouble() - 0.5) * width,
          height * 0.2,
        ).normalized()..scale(height / 4),
      ),
    );

    world.add(
      Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
      ),
    );

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is! KeyDownEvent &&
        !(event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyP:
      case LogicalKeyboardKey.escape:
        if (playState == PlayState.playing) {
          playState = PlayState.paused;
        } else if (playState == PlayState.paused) {
          playState = PlayState.playing;
        }
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowLeft:
        if (playState == PlayState.playing) {
          world.children.query<Bat>().first.moveBy(-batStep);
        }
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowRight:
        if (playState == PlayState.playing) {
          world.children.query<Bat>().first.moveBy(batStep);
        }
        return KeyEventResult.handled;

      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);

  void spawnBall() {
    world.add(
      Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2(
          (rand.nextDouble() - 0.5) * width,
          height * 0.2,
        ).normalized()..scale(height / 4),
      ),
    );
  }
}
