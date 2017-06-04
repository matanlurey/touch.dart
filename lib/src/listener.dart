// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:meta/meta.dart';

import 'detection.dart';

/// Abstraction around listening to mouse/press/touch events on an [Element].
///
/// ## Example Use
/// ```dart
/// new Listener().onStart(divElement).listen((e) { ... });
/// ```
abstract class Listener {
  /// Returns the best strategy for listening to press events on this device.
  ///
  /// Namely, `point`, then `touch`, then falls back to `mouse`.
  factory Listener() {
    return const [
      const Listener.point(),
      const Listener.touch(),
      const Listener.mouse(),
    ].firstWhere((l) => l.isSupported);
  }

  @literal
  const factory Listener.mouse() = _MouseListener;

  @literal
  const factory Listener.point() = _PointListener;

  @literal
  const factory Listener.touch() = _TouchListener;

  /// Returns a stream that will emit when a press starts on [element].
  Stream<Point> onStart(Element element);

  /// Returns a stream that will emit when movement occurs.
  Stream<Point> onMove(Element element);

  /// Returns a stream on release of press.
  Stream<Point> onEnd(Element element);

  /// Whether this listener is supported on the current device.
  bool get isSupported;
}

class _MouseListener implements Listener {
  static Point _point(MouseEvent e) => e.page;

  const _MouseListener();

  @override
  Stream<Point> onStart(Element element) => element.onMouseDown.map(_point);

  @override
  Stream<Point> onMove(Element element) => element.onMouseMove.map(_point);

  @override
  Stream<Point> onEnd(Element element) => element.onMouseUp.map(_point);

  @override
  bool get isSupported => true;
}

class _PointListener implements Listener {
  static const _down = 'pointerdown';
  static const _move = 'pointermove';
  static const _end = 'pointerup';

  static Point _point(PointerEvent e) => e.page;

  const _PointListener();

  @override
  Stream<Point> onStart(Element element) => element.on[_down].map(_point);

  @override
  Stream<Point> onMove(Element element) => element.on[_move].map(_point);

  @override
  Stream<Point> onEnd(Element element) => element.on[_end].map(_point);

  @override
  bool get isSupported => isPointerSupported;
}

class _TouchListener implements Listener {
  static Point _point(TouchEvent e) => e.changedTouches.first.page;

  const _TouchListener();

  @override
  Stream<Point> onStart(Element element) => element.onTouchStart.map(_point);

  @override
  Stream<Point> onMove(Element element) => element.onTouchMove.map(_point);

  @override
  Stream<Point> onEnd(Element element) => element.onTouchEnd.map(_point);

  @override
  bool get isSupported => isTouchSupported;
}
