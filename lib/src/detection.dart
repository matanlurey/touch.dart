// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library touch.src.detection;

import 'dart:html' show window;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('window.navigator.maxTouchPoints')
external int get _maxTouchPoints;

/// Whether pointer is supported.
bool get isPointerSupported => hasProperty(window, 'PointerEvent') as bool;

/// Whether touch is supported.
bool get isTouchSupported => hasProperty(window, 'ontouchstart') as bool;

/// Whether multi-touch is supported.
bool get isMultiTouchSupported {
  // Don't bother checking if we don't support touch.
  if (!isTouchSupported) {
    return false;
  }
  final isOS = new RegExp(r'\biPhone.*Mobile|\biPod|\biPad');
  // Assume all mobile Safari supports multi-touch.
  //
  // They don't support the "maxTouchPoints" API.
  if (isOS.hasMatch(window.navigator.userAgent)) {
    return true;
  }
  return _maxTouchPoints > 1;
}
