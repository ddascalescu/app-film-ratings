import 'package:flutter/material.dart';

class Indigo {
  static int value = 0xFF351091;

  static Color color = Color(value);

  static MaterialColor swatch = MaterialColor(value, const <int, Color>{
    50: Color.fromRGBO(53, 16, 145, 0.1),
    100: Color.fromRGBO(53, 16, 145, 0.2),
    200: Color.fromRGBO(53, 16, 145, 0.3),
    300: Color.fromRGBO(53, 16, 145, 0.4),
    400: Color.fromRGBO(53, 16, 145, 0.5),
    500: Color.fromRGBO(53, 16, 145, 0.6),
    600: Color.fromRGBO(53, 16, 145, 0.7),
    700: Color.fromRGBO(53, 16, 145, 0.8),
    800: Color.fromRGBO(53, 16, 145, 0.9),
    900: Color.fromRGBO(53, 16, 145, 1),
  });
}

abstract class AppTheme {
  ThemeData themeData();
  ThemeData themeDataPicker();
}

class AppThemeDark implements AppTheme {
  @override
  ThemeData themeData() {
    return ThemeData(
      primarySwatch: Indigo.swatch,
      brightness: Brightness.dark
    );
  }

  @override
  ThemeData themeDataPicker() {
    return themeData().copyWith(
      colorScheme: ColorScheme.light(
        primary: Indigo.color,
        onSurface: Colors.white
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white
        )
      )
    );
  }
}

class AppThemeLight implements AppTheme {
  @override
  ThemeData themeData() {
    return ThemeData(
        primarySwatch: Indigo.swatch,
        brightness: Brightness.light
    );
  }

  @override
  ThemeData themeDataPicker() {
    return themeData().copyWith(
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Indigo.color
            )
        )
    );
  }
}
