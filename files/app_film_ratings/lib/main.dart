import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:data_table_2/data_table_2.dart';

import 'utils/ratings.dart';
import 'formatters.dart';
import 'indigo.dart';

const String appTitle = 'Film Ratings';
const double pad = 8.0;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  final String lol = 'NutBulb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primarySwatch: Indigo.swatch,
          brightness: Brightness.dark
        ),
        home: const MainScreen()
    );
  }
}

// TODO: move this into MainScreen file, in screens folder
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        backgroundColor: Color(Indigo.indigo),
      ),
      body: const Padding(padding: EdgeInsets.all(pad),
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
      /* Top row */
      Row(
          children: [
            /* BUTTON: Add rating */
            Padding(
                padding: const EdgeInsets.all(pad),
                child: ElevatedButton(
                    child: const Text('Add rating...'),
                    onPressed: () { _showDialogAdd(); }
                )
            )
          ]
      ),

      /* DATA TABLE */
      Expanded(child:
      DataTable2(
        showCheckboxColumn: false,
        minWidth: 400,
        columnSpacing: pad,
        columns: const [
          DataColumn(label: Text('Title')),
          DataColumn2(label: Text('Year'), fixedWidth: 60),
          DataColumn2(label: Text('Rating'), fixedWidth: 60),
          DataColumn2(label: Text('Date'), fixedWidth: 60)
        ],
        rows: ratings
            .map((rating) => DataRow(cells: [
          DataCell(Text(rating.filmTitle, overflow: TextOverflow.ellipsis)),
          DataCell(Text(rating.filmYearString)),
          DataCell(Text(rating.ratingString)),
          DataCell(Text(rating.ratingDateStringShort))
        ],
        onSelectChanged: (bool? selected) { _showDialogDetails(rating); }
        ))
            .toList()
      )
      )
    ]);
  }

  void _resetFields() {
    _textController.clear();
    _yearController.clear();
    _numberController.clear();
    _selectedDate = DateTime.now();
  }

  void _showDialogAdd() {
    // TODO: make this boilerplate into a class
    showDialog(context: context,
        builder: (context) {
          return ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    /* DIALOG: Add rating */
                    body: Dialog(
                        child: Column(
                            children: [
                              /* TEXT: Dialog title */
                              const Text('Add rating'),

                              /* ENTRY: Film title */
                              SizedBox(width: 300, child: Row(children: [SizedBox(
                                  width: 300.0,
                                  child: Padding(
                                      padding: const EdgeInsets.all(pad),
                                      child: TextField(
                                          controller: _textController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(hintText: 'The Shawshank Redemption')
                                      )
                                  )
                              )])),

                              /* ENTRY: Film year */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Year:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            controller: _yearController,
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [YearInputFormatter()],
                                            decoration: const InputDecoration(hintText: '1994')
                                        )
                                    )
                                )])),

                              /* ENTRY: Rating */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Rating:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            controller: _numberController,
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [RatingInputFormatter()],
                                            decoration: const InputDecoration(hintText: '8.5')
                                        )
                                    )
                                )
                              ])),

                              /* ENTRY: Rating date */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Rating date:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: Ratings.dateFormat.format(_selectedDate),
                                            ),
                                            textAlign: TextAlign.right,

                                            onTap: () async {
                                              final DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: _selectedDate,
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );

                                              if (picked != null && picked != _selectedDate) {
                                                setState(() {
                                                  Navigator.pop(context); // This line...
                                                  _selectedDate = picked;
                                                  _showDialogAdd(); // and this line...
                                                  /* Is a hack to make the TextField update to
                                                  * show the newly selected date, as it wasn't
                                                  * before. It just closes and reopens the
                                                  * dialog box without calling resetFields(). */
                                                });
                                              }
                                            }

                                        )
                                    )
                                )
                              ])),

                              /* BUTTONS: Cancel and Add */
                              SizedBox(width: 300, child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.all(pad),
                                    child: ElevatedButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _resetFields();
                                          });
                                        }
                                    )
                                ),

                                const Expanded(child: Padding(padding: EdgeInsets.all(pad*2), child: Text(''))),

                                Padding(
                                    padding: const EdgeInsets.all(pad),
                                    child: ElevatedButton(
                                        child: const Text('Add'),
                                        onPressed: () {
                                          if (_tryAddRating(context)) {
                                            Navigator.pop(context);
                                          }
                                        }
                                    )
                                )
                              ]))
                            ]
                        )
                    )
                );
              })
          );
        }
    );
  }

  bool _tryAddRating(BuildContext dialogContext) {
    if (_textController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _numberController.text.isNotEmpty) {

      Rating r = Rating(
          _textController.text,
          int.parse(_yearController.text),
          double.parse(_numberController.text),
          _selectedDate
      );
      if (r.filmYear < 1850) {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
            const SnackBar(content: Text('Year must be greater than 1850'))
        );
        return false;
      }
      setState(() {
        ratings.add(r);
        _resetFields();
      });

      _submits = 0;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating added'))
      );
    } else {
      _submits++;
      if (_submits == 3) {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
            const SnackBar(content: Text('All fields must be completed'))
        );
        _submits = 0;
      }
      return false;
    }

    _writeRatings(ratings);
    return true;
  }

  void _removeRating(Rating rating) {
    setState(() {
      ratings.remove(rating);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating deleted'))
    );

    _writeRatings(ratings);
  }

  void _showDialogDetails(Rating rating) {
    showDialog(context: context,
        builder: (context) {
          return ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    /* DIALOG: Add rating */
                    body: Dialog(
                        child: Column(
                            children: [
                              /* TEXT: Dialog title */
                              const Text('Rating details'),

                              /* ENTRY: Film title */
                              SizedBox(width: 300, child: Row(children: [SizedBox(
                                  width: 300.0,
                                  child: Padding(
                                      padding: const EdgeInsets.all(pad),
                                      child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                            text: rating.filmTitle
                                          ),
                                          textAlign: TextAlign.center
                                      )
                                  )
                              )])),

                              /* ENTRY: Film year */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Year:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: rating.filmYearString
                                            ),
                                            textAlign: TextAlign.right
                                        )
                                    )
                                )])),

                              /* ENTRY: Rating */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Rating:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: rating.ratingString
                                            ),
                                            textAlign: TextAlign.right
                                        )
                                    )
                                )
                              ])),

                              /* ENTRY: Rating date */
                              SizedBox(width: 300, child: Row(children: [
                                const Padding(padding: EdgeInsets.all(pad*2),
                                    child: Text('Rating date:')
                                ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(pad),
                                        child: TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: rating.ratingDateString,
                                            ),
                                            textAlign: TextAlign.right
                                        )
                                    )
                                )
                              ])),

                              /* BUTTONS: Cancel and Add */
                              SizedBox(width: 300, child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.all(pad),
                                    child: ElevatedButton(
                                        child: const Text('Return'),
                                        onPressed: () { Navigator.pop(context); }
                                    )
                                ),

                                const Expanded(child: Padding(padding: EdgeInsets.all(pad*2), child: Text(''))),

                                Padding(
                                    padding: const EdgeInsets.all(pad),
                                    child: ElevatedButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _removeRating(rating);
                                        }
                                    )
                                )
                              ]))
                            ]
                        )
                    )
                );
              })
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _readRatings().then((ratings) {
      setState(() {
        this.ratings.addAll(ratings);
      });
    });
  }

  Future<File> _writeRatings(List<Rating> ratings) async {
    final file = await _localFile;
    String data = Ratings.encode(ratings);
    return file.writeAsString(data);
  }

  Future<List<Rating>> _readRatings() async {
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
