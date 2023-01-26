import 'package:app_film_ratings/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:google_fonts/google_fonts.dart';

import 'package:data_table_2/data_table_2.dart';

import 'utils/globals.dart';
import 'classes/ratings.dart';
import 'utils/formatters.dart';
import 'utils/colors.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  final String lol = 'NutBulb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        theme: appTheme.themeData(),
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
        title: Text(appTitle.toLowerCase(),
          style: GoogleFonts.getFont('Inter')
        ),
        backgroundColor: Indigo.color,
        actions: [
          PaddingAll(
            padding: 0,
            child: Image.asset('assets/icons/indigo.png'),
          ),
          const PaddingAll(padding: pad)
        ]
      ),
      body: const PaddingAll(
          padding: pad,
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
  int _selectedDropdown = 1;

  final List<Rating> ratings = [];

  @override
  Widget build(BuildContext context) {
    // TODO: make minimum size for window (min size for certain widgets)
    return Column(children: [
      /* Top row */
      Row(
          children: [
            /* BUTTON: Add rating */
            PaddingAll(
                padding: pad,
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
        minWidth: 300,
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
    _selectedDropdown = 1;
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

                              // TODO: make these into a class
                              /* ENTRY: Film title */
                              InputRow(
                                  child: TextField(
                                      controller: _textController,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(hintText: 'The Shawshank Redemption')
                                  )
                              ),

                              /* ENTRY: Film year */
                              InputRow(
                                  prompt: "Year:",
                                  child: TextField(
                                      controller: _yearController,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [YearInputFormatter()],
                                      decoration: const InputDecoration(hintText: '1994')
                                  )
                              ),

                              /* ENTRY: Rating */
                              InputRow(
                                  prompt: "Rating:",
                                  child: TextField(
                                      controller: _numberController,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [RatingInputFormatter()],
                                      decoration: const InputDecoration(hintText: '8.5')
                                  )
                              ),

                              /* ENTRY: Rating date */
                              InputRow(
                                  prompt: "Rating date:",
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
                                            builder: (BuildContext context, Widget? child) {
                                              return Theme(
                                                  data: appTheme.themeDataPicker(),
                                                  child: child!
                                              );
                                            }
                                        );

                                        if (picked != null && picked != _selectedDate) {
                                          setState(() {
                                            Navigator.pop(context); // This line...
                                            _selectedDate = picked;
                                            _showDialogAdd(); // and this line...
                                            /* ... is a hack to make the TextField update to
                                                      * show the newly selected date, as it wasn't
                                                      * before. It just closes and reopens the
                                                      * dialog box without calling resetFields(). */
                                            // TODO: find better fix, if reloading affects performance
                                            // might be because of async
                                          });
                                        }
                                      }

                                  )
                              ),

                              /* Description */
                              InputRow(
                                  prompt: "Description:",
                                  child: DropdownButton<int>(
                                      value: _selectedDropdown,
                                      isExpanded: true,
                                      iconSize: 0.0,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          // TODO: requires fix as above
                                          Navigator.pop(context);
                                          _selectedDropdown = newValue!;
                                          _showDialogAdd();
                                        });
                                      },
                                      items: Ratings.descriptions.entries
                                          .map((entry) => DropdownMenuItem<int>(
                                          value: entry.key,
                                          child: Text(entry.value, overflow: TextOverflow.ellipsis,)
                                      ))
                                          .toList()
                                  )
                              ),

                              /* BUTTONS: Cancel and Add */
                              SizedBox(width: dialogInnerWidth, child: Row(children: [
                                PaddingAll(
                                    padding: pad,
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

                                const Expanded(child: PaddingAll(padding: pad*2, child: Text(''))),

                                PaddingAll(
                                    padding: pad,
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
          _selectedDate,
          _selectedDropdown
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

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating added'))
      );
    } else {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
          const SnackBar(content: Text('All fields must be completed'))
      );
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
                              InputRow(
                                  child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: rating.filmTitle
                                      ),
                                      textAlign: TextAlign.center
                                  )
                              ),

                              /* ENTRY: Film year */
                              InputRow(
                                  prompt: "Year:",
                                  child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: rating.filmYearString
                                      ),
                                      textAlign: TextAlign.right
                                  )
                              ),

                              /* ENTRY: Rating */
                              InputRow(
                                  prompt: "Rating:",
                                  child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: rating.ratingString
                                      ),
                                      textAlign: TextAlign.right
                                  )
                              ),

                              /* ENTRY: Rating date */
                              InputRow(
                                prompt: "Rating date:",
                                child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text: rating.ratingDateString,
                                    ),
                                    textAlign: TextAlign.right
                                )
                              ),

                              /* ENTRY: Description */
                              InputRow(
                                  prompt: "Description:",
                                  child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                        text: Ratings.descriptions[rating.descriptionId],
                                      ),
                                      textAlign: TextAlign.right
                                  )
                              ),

                              /* BUTTONS: Cancel and Add */
                              SizedBox(width: dialogInnerWidth, child: Row(children: [
                                PaddingAll(
                                    padding: pad,
                                    child: ElevatedButton(
                                        child: const Text('Return'),
                                        onPressed: () { Navigator.pop(context); }
                                    )
                                ),

                                const Expanded(child: PaddingAll(padding: pad*2, child: Text(''))),

                                PaddingAll(
                                    padding: pad,
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
