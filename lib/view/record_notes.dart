import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecordNotes extends StatelessWidget {
  RecordNotes({super.key, required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Text('Record ::: $index '),
        ),
      ),
    );
  }
}
