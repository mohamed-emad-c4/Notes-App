// hide_notes.dart
import 'package:flutter/material.dart';
import 'package:test1/DB/hide.dart';
import 'package:test1/models/note.dart';

class HiddenNotesScreen extends StatefulWidget {
  const HiddenNotesScreen({super.key});

  @override
  _HiddenNotesScreenState createState() => _HiddenNotesScreenState();
}

class _HiddenNotesScreenState extends State<HiddenNotesScreen> {
  late Future<List<NoteModel>> _hiddenNotes;

  @override
  void initState() {
    super.initState();
    _hiddenNotes = _fetchHiddenNotes();
  }

  Future<List<NoteModel>> _fetchHiddenNotes() async {
    final db = Hide.instance;

    return db.readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hidden Notes')),
      body: FutureBuilder<List<NoteModel>>(
        future: _hiddenNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hidden notes found.'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () {
                    // Handle note tap if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
