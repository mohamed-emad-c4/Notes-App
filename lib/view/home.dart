import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/cubit/setting_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/models/note.dart';
import 'package:test1/view/add_note.dart';
import 'package:test1/view/more_view/Favorite.dart';
import 'package:test1/view/more_view/creat_PIN.dart';
import 'package:test1/view/more_view/hide_notes.dart';
import 'package:test1/view/record_notes.dart';

import 'more_view/archive.dart';
import 'more_view/deleted.dart';
import 'more_view/setting.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.allNotes});
  List<NoteModel> allNotes;
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UpdateCubit(),
        ),
        BlocProvider(
          create: (context) => SettingCubit(),
        ),
      ],
      child: BlocConsumer<UpdateCubit, UpdateState>(
        listener: (context, state) {
          if (state is ChangeTheme) {
            isDarkMode = !isDarkMode;
          }
        },
        builder: (context, state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes Recorder',
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: BlocBuilder<UpdateCubit, UpdateState>(
              builder: (context, state) {
                if (state is UpdateInitial) {
                  return Notes(allNotes: allNotes);
                }
                if (state is AddNoteState) {
                  return AddNote(allNotes: allNotes);
                } else if (state is UpdateNotes) {
                  return Notes(allNotes: state.allNotes);
                } else {
                  const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  return Container();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class Notes extends StatelessWidget {
  const Notes({
    super.key,
    required this.allNotes,
  });

  final List<NoteModel> allNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        
                      },
                      child: const Text(
                        'Not',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      'es Recorder',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'Deleted',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20),
                              SizedBox(width: 10),
                              Text('Deleted'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Archived',
                          child: Row(
                            children: [
                              Icon(Icons.archive, size: 20),
                              SizedBox(width: 10),
                              Text('Archived'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Favorites',
                          child: Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 20),
                              SizedBox(width: 10),
                              Text('Favorites'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, size: 20),
                              SizedBox(width: 10),
                              Text('Settings'),
                            ],
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == 'Deleted') {
                          Get.to(const DeletedNotes());
                        } else if (value == 'Archived') {
                          Get.to(const ArchivedList());
                        } else if (value == 'Favorites') {
                          Get.to(const FavoriteList());
                        } else if (value == 'Settings') {
                          Get.to(const Setting());
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: const Key("notes"), // مفتاح مميز لكل عنصر
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        BlocProvider.of<UpdateCubit>(context)
                            .AddNoteToArchive(allNotes: allNotes, index: index);
                        BlocProvider.of<UpdateCubit>(context).updateNotes();
                      } else if (direction == DismissDirection.endToStart) {
                        BlocProvider.of<UpdateCubit>(context)
                            .AddNoteToDeleted(allNotes: allNotes, index: index);
                      }
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green,
                      ), // لون الأرشفة
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.archive, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      // لون الحذف
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: RecordNotes(
                      allNotes: allNotes,
                      index: index,
                    ),
                  );
                },
                itemCount: allNotes.length,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 90, // Adjust positioning as needed
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(AddNote(allNotes: allNotes));
              },
              heroTag: 'addNoteButton',
              child: const Icon(Icons.add), // Unique tag for this button
            ),
          ),
          Positioned(
            bottom: 170, // Adjust positioning as needed
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
              },
              heroTag: 'micButton',
              child: const Icon(Icons.mic), // Unique tag for this button
            ),
          ),
        ],
      ),
    );
  }
}
