import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.milliseconds});

  final int milliseconds;
  Timer? timer;

  void call(VoidCallback callback) {
    cancel();

    timer = Timer(Duration(milliseconds: milliseconds), callback);
  }

  void cancel() {
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
  }
}
