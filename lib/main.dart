import 'package:flutter/material.dart';

import 'config/theme_app.dart';
import 'services/service_locator.dart';
import 'views/home_screen_view.dart';
import 'widgets/no_glow_effect.dart';

void main() {
  setupLocator();

  runApp(const MandelbrotApp());
}

class MandelbrotApp extends StatelessWidget {
  const MandelbrotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandelbrot',
      theme: ThemeApp.darkTheme,
      debugShowCheckedModeBanner: false,
      builder: (_, child) {
        return ScrollConfiguration(
          behavior: const NoGlowEffect(),
          child: child!,
        );
      },
      home: HomeScreenView(),
    );
  }
}
