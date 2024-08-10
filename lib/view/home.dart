import 'dart:developer';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/cubit/change_lan_cubit.dart';
import 'package:test1/cubit/cubit/cubit/archive_update_cubit.dart';
import 'package:test1/cubit/cubit/cubit/deleted%20cubit/deleted_update_cubit.dart';
import 'package:test1/cubit/cubit/setting_cubit.dart';
import 'package:test1/cubit/favorit_update_cubit.dart';
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/cubit/hide_notes_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/view/add_note.dart';
import 'package:test1/view/more_view/Favorite.dart';
import 'package:test1/view/more_view/creat_PIN.dart';
import 'package:test1/view/more_view/enter_PIN.dart';
import 'package:test1/view/record_notes.dart';
import 'more_view/archive.dart';
import 'more_view/deleted.dart';
import 'more_view/setting.dart';

class Home extends StatelessWidget {
  Home(
      {super.key,
      required this.allNotes,
      required this.isDarkMode,
      required this.SelectLang});
  List<NoteModel> allNotes;
  bool isDarkMode;
  String SelectLang;

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
        BlocProvider(
          create: (context) => HideNotesCubit(),
        ),
        BlocProvider(
          create: (context) => ArchiveUpdateCubit(),
        ),
        BlocProvider(
          create: (context) => DeletedUpdateCubit(),
        ),
        BlocProvider(
          create: (context) => FavoritUpdateCubit(),
        ),
        BlocProvider(
          create: (context) => HideCubitCubit(),
        ),
        BlocProvider(
          create: (context) => ChangeLanCubit(),
        ),
      ],
      child: BlocConsumer<UpdateCubit, UpdateState>(
        listener: (context, state) {
          if (state is ChangeTheme) {
            isDarkMode = !isDarkMode;
          } else if (state is ChangeLanguage) {}
        },
        builder: (context, state) {
          return BlocListener<HideNotesCubit, HideNotesState>(
            listener: (context, hideNotesState) {
              if (hideNotesState is HideNotesCreatPIN) {
                Get.to(const CreatePinScreen());
              } else if (hideNotesState is HideNotesEnterPIN) {
                Get.to(const EnterPinScreen());
              }
            },
            child: BlocBuilder<ChangeLanCubit, ChangeLanState>(
              builder: (context, state) {
                if (state is ChangeLanSuccess) {
                  SelectLang = state.SelectLang;
                  log(SelectLang);
                  log("$state");
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    locale: Locale(state.SelectLang),
                    title: 'Notes Recorder',
                    theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                    home: BlocBuilder<UpdateCubit, UpdateState>(
                      builder: (context, state) {
                        if (state is UpdateInitial) {
                          return Notes(
                              allNotes: allNotes, isDarkMode: isDarkMode);
                        }
                        if (state is AddNoteState) {
                          return AddNote(allNotes: allNotes);
                        } else if (state is UpdateNotes) {
                          return Notes(
                              allNotes: state.allNotes, isDarkMode: isDarkMode);
                        } else if (state is HideNotesCreatPIN) {
                          Get.to(const CreatePinScreen());
                          return const CreatePinScreen();
                        } else if (state is HideNotesEnterPIN) {
                          Get.to(const EnterPinScreen());
                          return const EnterPinScreen();
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
                } else if (state is ChangeLanInitial) {
                  log(SelectLang);
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    locale: Locale(SelectLang),
                    title: 'Notes Recorder',
                    theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                    home: BlocBuilder<UpdateCubit, UpdateState>(
                      builder: (context, state) {
                        if (state is UpdateInitial) {
                          return Notes(
                              allNotes: allNotes, isDarkMode: isDarkMode);
                        }
                        if (state is AddNoteState) {
                          return AddNote(allNotes: allNotes);
                        } else if (state is UpdateNotes) {
                          return Notes(
                              allNotes: state.allNotes, isDarkMode: isDarkMode);
                        } else if (state is HideNotesCreatPIN) {
                          Get.to(const CreatePinScreen());
                          return const CreatePinScreen();
                        } else if (state is HideNotesEnterPIN) {
                          Get.to(const EnterPinScreen());
                          return const EnterPinScreen();
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
                } else {
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
  Notes({
    super.key,
    required this.allNotes,
    required this.isDarkMode,
  });

  final List<NoteModel> allNotes;
  bool isDarkMode;

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
                        log('home');
                        BlocProvider.of<HideNotesCubit>(context).chechPIN();
                      },
                      child: Text(
                        S.of(context).Notes,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      S.of(context).Recorder,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'Deleted',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Deleted),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Archived',
                          child: Row(
                            children: [
                              const Icon(Icons.archive, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Archived),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Favorites',
                          child: Row(
                            children: [
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Favorites),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Settings',
                          child: Row(
                            children: [
                              const Icon(Icons.settings, size: 20),
                              const SizedBox(width: 10),
                              Text(S.of(context).Settings),
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
                          Get.to(Setting(
                            isDarkMode: isDarkMode,
                          ));
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
                    key: Key("$index"), // مفتاح مميز لكل عنصر
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        try {
                          BlocProvider.of<UpdateCubit>(context)
                              .AddNoteToArchive(
                                  allNotes: allNotes, index: index);
                          BlocProvider.of<UpdateCubit>(context).updateNotes();
                          Get.snackbar("Done", "Added to archive");
                          BlocProvider.of<UpdateCubit>(context).updateNotes();
                        } catch (e) {
                          Get.snackbar("Error", "Failed to add note");
                        }
                      } else if (direction == DismissDirection.endToStart) {
                        try {
                          BlocProvider.of<UpdateCubit>(context)
                              .AddNoteToDeleted(
                                  allNotes: allNotes, index: index);
                          BlocProvider.of<UpdateCubit>(context).updateNotes();
                          Get.snackbar("Done", "Deleted ");
                        } catch (e) {
                          Get.snackbar("Error", "Failed to delete note");
                        }
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
        ],
      ),
    );
  }
}
