import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'utils/ratings.dart';

const String appTitle = 'Film Ratings';

void main()  => runApp(const App());


class App extends StatelessWidget {
  const App({super.key});

  final String lol = 'NutBulb';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MainScreen()
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextEntryList()
      ),

    );
  }
}

class TextEntryList extends StatefulWidget {
  const TextEntryList({super.key});

  @override
  State<TextEntryList> createState() => _TextEntryListState();
}

class _TextEntryListState extends State<TextEntryList> {
  final _textController = TextEditingController();
  final _numberController = TextEditingController();
  final _yearController = TextEditingController();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();

  final NumberFormat ratingFormat = NumberFormat('##');

  final _items = <String>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'The Shawshank Redemption'
                  )
                ),
              ),
            ),

            SizedBox(
              width: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _yearController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      YearInputFormatter()
                    ],
                    decoration: const InputDecoration(
                        hintText: '1994'
                    )
                ),
              ),
            ),

            SizedBox(
              width: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _numberController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    RatingInputFormatter()
                  ],
                  decoration: const InputDecoration(
                    hintText: '8.5'
                  )
                ),
              ),
            ),

            SizedBox(
              width: 150.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: dateFormat.format(_selectedDate),
                  ),
                  textAlign: TextAlign.center,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  }
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  if (_textController.text.isNotEmpty && _numberController.text.isNotEmpty) {
                    setState(() {
                      _items.add(
                          "${_textController.text} (${_yearController.text}), ${double.parse(_numberController.text).toStringAsFixed(1)}, ${dateFormat.format(_selectedDate)}"
                      );
                      Rating r = Rating(
                          _textController.text,
                          int.parse(_yearController.text),
                          double.parse(_numberController.text),
                          _selectedDate
                      );
                      print('\n${r}');

                      _textController.clear();
                      _yearController.clear();
                      _numberController.clear();
                      _selectedDate = DateTime.now();
                    });
                  } else {
                    // TODO: warn user that text is empty
                  }
                },
              ),
            ),
          ],
        ),

        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
