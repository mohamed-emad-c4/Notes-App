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
          child: Row(
            children: [
              Text('Record ::: $index '),
              const Spacer(),
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'Deleted',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Deleted'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Archived',
                    child: Row(
                      children: [
                        Icon(
                          Icons.archive,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Archived'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Favorites',
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Favorites'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'Deleted') {
                  } else if (value == 'Archived') {
                  } else if (value == 'Favorites') {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
