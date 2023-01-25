import 'package:flutter/services.dart';

class YearInputFormatter extends TextInputFormatter {
  final int minValue = 0000;
  final int maxValue = DateTime.now().year;
  final regex = RegExp(r'^\d+$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > maxValue) {
      return oldValue;
    }
    if (value < minValue) {
      return oldValue;
    }

    return newValue;
  }
}

class RatingInputFormatter extends TextInputFormatter {
  final double minValue = 0.0;
  final double maxValue = 10.0;
  final regex = RegExp(r'^\d\.?\d?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final double? value = double.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > maxValue) {
      return oldValue;
    }
    if (value < minValue) {
      return oldValue;
    }

    return newValue;
  }
}
