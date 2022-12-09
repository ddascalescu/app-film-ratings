import 'package:flutter/material.dart';

const String appTitle = 'Film Ratings';

void main()  => runApp(const App());


class App extends StatelessWidget {
  const App({super.key});

  final String lol = "NutBulb";

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
  final _items = <String>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'The Shawshank Redemption',
                  )
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    hintText: '8.5',
                    counterText: '',
                  )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  setState(() {
                    _items.add("${_textController.text}, ${_numberController.text}");
                  });
                  _textController.clear();
                  _numberController.clear();
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


