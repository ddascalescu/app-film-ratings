import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:data_table_2/data_table_2.dart';

import 'utils/ratings.dart';
import 'formatters.dart';

const String appTitle = 'Film Ratings';

void main() => runApp(const App());

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
      // TODO: make appbar indigo
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      // TODO: make all paddings into a decorator
      body: const Padding(padding: EdgeInsets.all(8.0),
          child: RatingsTable()
      )
    );
  }
}

class RatingsTable extends StatefulWidget {
  const RatingsTable({super.key});

  @override
  State<RatingsTable> createState() => _RatingsTableState();
}

class _RatingsTableState extends State<RatingsTable> {
  final _textController = TextEditingController();
  final _numberController = TextEditingController();
  final _yearController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  int _submits = 0;

  final List<Rating> ratings = [];

  @override
  Widget build(BuildContext context) {
    // TODO: make minimum size for window (min size for certain widgets)
    return Column(children: [
      /* Entries row */
      Row(
        children: [
          /* ENTRY: Film title */
          Expanded(
            child: Padding(padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'The Shawshank Redemption')
              )
            )
          ),

          /* ENTRY: Film year */
          SizedBox(
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _yearController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [YearInputFormatter()],
                decoration: const InputDecoration(hintText: '1994')
              )
            )
          ),

          /* ENTRY: Rating */
          SizedBox(
            width: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _numberController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [RatingInputFormatter()],
                decoration: const InputDecoration(hintText: '8.5')
              )
            )
          ),

          /* ENTRY: Rating date */
          SizedBox(
            width: 150.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: Ratings.dateFormat.format(_selectedDate),
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

              )
            )
          ),

          /* BUTTON: Add rating */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text('Add'),
              onPressed: () { addRating(); }
            )
          )
        ]
      ),

      /* Data table headers */
      Expanded(child:
        DataTable2(
          columns: const [
            DataColumn(label: Text('Title')),
            DataColumn2(label: Text('Year'), fixedWidth: 100),
            DataColumn2(label: Text('Rating'), fixedWidth: 100),
            DataColumn2(label: Text('Date'), fixedWidth: 150),
            DataColumn2(label: Text(''), fixedWidth: 75)
          ],
          rows: ratings
              .map((rating) => DataRow(cells: [
            DataCell(Text(rating.filmTitle)),
            DataCell(Text(rating.yearString)),
            DataCell(Text(rating.ratingString)),
            DataCell(Text(rating.ratingDateString)),
            DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () { removeRating(rating); }
            ))
          ]))
              .toList()
        )
      )
    ]);
  }

  void addRating() {
    if (_textController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _numberController.text.isNotEmpty) {

      Rating r = Rating(
        _textController.text,
        int.parse(_yearController.text),
        double.parse(_numberController.text),
        _selectedDate
      );
      setState(() {
        ratings.add(r);

        _textController.clear();
        _yearController.clear();
        _numberController.clear();
        _selectedDate = DateTime.now();
      });

      _submits = 0;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating added'))
      );
    } else {
      _submits++;
      if (_submits == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All fields must be completed'))
        );
        _submits = 0;
      }
    }

    writeRatings(ratings);
  }

  void removeRating(Rating rating) {
    setState(() {
      ratings.remove(rating);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating deleted'))
    );

    writeRatings(ratings);
  }

  @override
  void initState() {
    super.initState();
    readRatings().then((ratings) {
      setState(() {
        this.ratings.addAll(ratings);
      });
    });
  }

  Future<File> writeRatings(List<Rating> ratings) async {
    final file = await _localFile;
    String data = Ratings.encode(ratings);
    return file.writeAsString(data);
  }

  Future<List<Rating>> readRatings() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      return Ratings.decode(data);
    } catch (e) {
      return [];
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(p.join(path, 'Film Ratings', 'ratings.json')).create(recursive: true);
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
