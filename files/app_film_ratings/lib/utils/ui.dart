import 'package:flutter/material.dart';

import 'globals.dart';

class InputRow extends StatelessWidget {
  final String? prompt;
  final Widget child;

  const InputRow({super.key, this.prompt, required this.child});

  @override
  Widget build(BuildContext context) {
    if (prompt == null) {
      return SizedBox(width: dialogInnerWidth, child: Row(children: [SizedBox(
          width: dialogInnerWidth,
          child: PaddingAll(
              padding: pad,
              child: child
          )
      )]));
    } else {
      return SizedBox(width: dialogInnerWidth, child: Row(children: [
        PaddingAll(
            padding: pad*2,
            child: Text(prompt!)
        ),
        Expanded(
            child: PaddingAll(
                padding: pad,
                child: child
            )
        )]));
    }
  }
}

class PaddingAll extends StatelessWidget {
  final double padding;
  final Widget? child;

  const PaddingAll({super.key, required this.padding, this.child});

  @override
  Widget build(BuildContext context)  {
      return Padding(
          padding: EdgeInsets.all(padding),
          child: child
      );
  }
}
