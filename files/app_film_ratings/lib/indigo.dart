import 'package:flutter/material.dart';

class Indigo {
  static int indigo = 0xFF351091;

  static swatch() {
    return MaterialColor(indigo, const <int, Color>{
      50: Color.fromRGBO(53, 16, 145, 0.1),
      100: Color.fromRGBO(53, 16, 145, 0.2),
      200: Color.fromRGBO(53, 16, 145, 0.3),
      300: Color.fromRGBO(53, 16, 145, 0.4),
      400: Color.fromRGBO(53, 16, 145, 0.5),
      500: Color.fromRGBO(53, 16, 145, 0.6),
      600: Color.fromRGBO(53, 16, 145, 0.7),
      700: Color.fromRGBO(53, 16, 145, 0.8),
      800: Color.fromRGBO(53, 16, 145, 0.9),
      900: Color.fromRGBO(53, 16, 145, 1)
    });
  }
}
