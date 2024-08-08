import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/DB/hide.dart'; // Import your database class
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/models/note.dart';
import 'package:test1/view/more_view/add_hide_note.dart';

import '../record_notes.dart'; // Import your NoteModel

class HiddenNotesScreen extends StatelessWidget {
  const HiddenNotesScreen({super.key});

  Future<List<NoteModel>> _fetchHiddenNotes() async {
    final db = Hide.instance; // Your database instance
    return db.readAllNotes(); // Fetch all hidden notes
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<HideCubitCubit>(context),
        builder: (context, state) {
          if (state is HideCubitInitial|| state is HideCubitUpdated) {
             return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Notes'),
      ),
      body: FutureBuilder<List<NoteModel>>(
        future:
            _fetchHiddenNotes(), // Call the async function to fetch hidden notes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is returned or the list is empty
            return const Center(child: Text('No hidden notes found.'));
          } else {
            // If the data is successfully loaded
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return RecordNotesHide(
                  allNotes: notes,
                  index: index,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(AddHideNote(allNotes: const []));
          // Optionally, show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note added successfully!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }else{
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

 
        });
  }
}
