import 'package:flutter/material.dart';

class NoGlowEffect extends ScrollBehavior {
  /// Widget criado para retirar o efeito de 'glowing effect' ao ter um 'overscroll' em uma lista
  const NoGlowEffect();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
