import 'package:flutter/material.dart';

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

  final List<Rating> ratings = [];

  @override
  Widget build(BuildContext context) {
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
                // TODO: maybe make this not a controller?
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

              onPressed: () {
                // TODO: put into addItem method
                if (_textController.text.isNotEmpty &&
                    _numberController.text.isNotEmpty) {
                  setState(() {
                    Rating r = Rating(
                        _textController.text,
                        int.parse(_yearController.text),
                        double.parse(_numberController.text),
                        _selectedDate);
                    addRating(r);

                    _textController.clear();
                    _yearController.clear();
                    _numberController.clear();
                    _selectedDate = DateTime.now();
                  });
                } else {
                  // TODO: warn user that text is empty
                }
              }

            )
          )
        ]
      ),

      /* Data table */
      // TODO: make title the only column that expands
      // TODO: make table vertically scrollable
      // TODO: might not need this hack, maybe just row and expanded
      Row(children: [Expanded(child: SingleChildScrollView( // hack to make DataTable fit width
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Rating')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text(''))
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
      ))])
    ]);
  }

  void addRating(Rating rating) {
    setState(() {
      ratings.add(rating);
    });
  }

  void removeRating(Rating rating) {
    setState(() {
      ratings.remove(rating);
    });
  }
}
