import 'package:flutter/material.dart';

class ThemeApp {
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blue[700],
    inputDecorationTheme: InputDecorationTheme(
      border: _outlineBorder,
      errorBorder: _outlineBorder,
      enabledBorder: _outlineBorder,
      focusedBorder: _outlineBorder,
      disabledBorder: _outlineBorder,
      focusedErrorBorder: _outlineBorder,
      hintStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    ),
  );

  static final _outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      width: 1.2,
      color: Colors.grey[300]!,
    ),
  );
}
