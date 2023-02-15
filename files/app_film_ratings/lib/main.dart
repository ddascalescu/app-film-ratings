import 'dart:convert';

import 'package:app_film_ratings/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:desktop_window/desktop_window.dart';

import 'utils/globals.dart';
import 'classes/ratings.dart';
import 'utils/formatters.dart';
import 'utils/colors.dart';

//TODO make text quotes consistent
var logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    DesktopWindow.setMinWindowSize(const Size(200, 300));
    DesktopWindow.setWindowSize(const Size(600, 800));
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final String lol = 'NutBulb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        theme: appTheme.themeData(),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('en', 'GB'),
          Locale('en', 'US')
        ],
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
  final _descrController = TextEditingController();

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
    _descrController.clear();
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
                                      textCapitalization: TextCapitalization.sentences,
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
                                            locale: const Locale('en', 'GB'),
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

                              /* ENTRY: Type */
                              InputRow(
                                  prompt: "Type:",
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
                                      items: Ratings.types.entries
                                          .map((entry) => DropdownMenuItem<int>(
                                          value: entry.key,
                                          child: Text(entry.value)
                                      ))
                                          .toList(),
                                      selectedItemBuilder: (BuildContext context) {
                                        return Ratings.types.entries.map<Widget>((_) {
                                          return Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(Ratings.types[_selectedDropdown]!, overflow: TextOverflow.ellipsis)
                                          );
                                        })
                                            .toList();
                                      }
                                  )
                              ),

                              /* ENTRY: Description */
                              SizedBox(width: dialogInnerWidth, height: 100, child: PaddingAll(padding: pad,
                                  child: TextField(
                                      controller: _descrController,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: const InputDecoration(
                                          hintText: "Optional description...",
                                          border: OutlineInputBorder()
                                      ),
                                      minLines: 3,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 14
                                      )
                                  )
                              )),

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
          _selectedDropdown,
          _descrController.text
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
                                  child: PaddingAll(padding: pad, child: Text(
                                      rating.filmTitle,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15
                                      )
                                  )
                              )),

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

                              /* ENTRY: Type */
                              InputRow(
                                  prompt: "Type:",
                                  child: Text(
                                      Ratings.types[rating.typeId] ?? "",
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15
                                      )
                                  )
                              ),

                              SizedBox(width: dialogInnerWidth, height: 100, child: PaddingAll(padding: pad,
                                  child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                        text: rating.description
                                      ),
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()
                                      ),
                                      minLines: 3,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 14
                                      )
                                  )
                              )),

                              /* BUTTONS: Return and Delete */
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
                                          _showDialogDelete(context, rating);
                                          //Navigator.pop(context);
                                          //_removeRating(rating);
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

  void _showDialogDelete(BuildContext parentContext, Rating rating) {
    showDialog(context: context,
        builder: (context) {
          return ScaffoldMessenger(
              child: Builder(builder: (context) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    /* DIALOG: Delete check */
                    body: Dialog(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /* TEXT: Check */
                              SizedBox(width: dialogInnerWidth, child: PaddingAll(padding: pad*2,
                                child: Text(
                                  "Are you sure you wish to delete this rating of "
                                    "\"${rating.filmTitle}\" from ${rating.ratingDateString}?",
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center
                                ),
                              )),

                              /* BUTTONS: Cancel and Delete */
                              SizedBox(width: dialogInnerWidth, child: Row(children: [
                                PaddingAll(
                                    padding: pad,
                                    child: ElevatedButton(
                                        child: const Text('Cancel'),
                                        onPressed: () { Navigator.pop(context); }
                                    )
                                ),

                                const Expanded(child: PaddingAll(padding: pad*2, child: Text(''))),

                                PaddingAll(
                                    padding: pad,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF8A192F)
                                        ),
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(parentContext);
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

    _createBackupIfNeeded();

    _readRatings().then((ratings) {
      setState(() {
        this.ratings.addAll(ratings);
      });
    });
  }

  void _createBackupIfNeeded() async {
    final directory = await _localBackupDir;
    final File? latest = getMostRecentFile(directory);

    if (latest == null || latest.lastModifiedSync().isBefore(DateTime.now().subtract(const Duration(days: 7)))) {
      final file = await _localFile;
      String newPath = p.join(directory.path, '${DateFormat('yyyyMMdd').format(DateTime.now())}_${p.basename(file.path)}');
      file.copy(newPath);
      logger.i("Backup created:"
          "\n\tpath: $newPath");
    }
  }

  Future<Directory> get _localBackupDir async {
    final path = await _localPath;
    return Directory(p.join(path, 'backups')).create();
  }

  Future<File> _writeRatings(List<Rating> ratings) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final file = await _localFile;
    String data = Ratings.encode(ratings, packageInfo.version);
    return file.writeAsString(data);
  }

  Future<List<Rating>> _readRatings() async {
    List<Rating> r = [];

    try {
      final file = await _localFile;
      String data = await file.readAsString();

      try {
        r = Ratings.decode(data);
      } on AssertionError catch (_) {
        // TODO remove this when all updated
        var x = jsonDecode(data);
        if (x is List) {
          logger.i("Ratings file is version <= 0.2.0"
              "\n\tUpdating...");
          r = Ratings.decodeList(x, '');
          _writeRatings(r);
        }
      }
    } catch (e) {
      logger.e("Error reading from file:"
          "\n\t$e");
    }

    return r;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(p.join(path, 'ratings.json')).create();
  }
}

File? getMostRecentFile(Directory directory) {
  final files = directory.listSync().whereType<File>().toList();
  if (files.isEmpty) {
    return null;
  }

  files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  return files.first;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return p.join(directory.path, appTitle);
}
