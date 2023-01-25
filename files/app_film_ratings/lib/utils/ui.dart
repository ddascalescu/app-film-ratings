import 'package:flutter/material.dart';

import 'globals.dart';

class InputRow extends StatelessWidget {
  final String prompt;
  final StatelessWidget child;

  const InputRow({super.key, required this.prompt, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: dialogInnerWidth, child: Row(children: [
      Padding(padding: const EdgeInsets.all(pad*2),
          child: Text(prompt)
      ),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(pad),
              child: child
          )
      )]));
  }

}