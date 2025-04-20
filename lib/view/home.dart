import 'dart:developer';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
import 'package:test1/shared/app_theme.dart';
import 'package:test1/shared/tutorial_screen.dart';
import 'package:test1/view/add_note.dart';
import 'package:test1/view/more_view/creat_PIN.dart';
import 'package:test1/view/more_view/enter_PIN.dart';
import 'package:test1/widgets/Notes.dart';
import 'package:test1/widgets/app_logo.dart';

import 'todo/todo.dart';

class Home extends StatelessWidget {
  Home({
    super.key,
    required this.allNotes,
    required this.isDarkMode,
    required this.SelectLang,
  });

  final List<NoteModel> allNotes;
  bool isDarkMode;
  String SelectLang;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateCubit()),
        BlocProvider(create: (context) => SettingCubit()),
        BlocProvider(create: (context) => HideNotesCubit()),
        BlocProvider(create: (context) => ArchiveUpdateCubit()),
        BlocProvider(create: (context) => DeletedUpdateCubit()),
        BlocProvider(create: (context) => FavoritUpdateCubit()),
        BlocProvider(create: (context) => HideCubitCubit()),
        BlocProvider(create: (context) => ChangeLanCubit()),
      ],
      child: BlocConsumer<UpdateCubit, UpdateState>(
        listener: (context, state) {
          if (state is ChangeTheme) {
            isDarkMode = !isDarkMode;
          }
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

                  return _buildGetMaterialApp(
                      context, SelectLang, isDarkMode, allNotes);
                } else if (state is ChangeLanInitial) {
                  log(SelectLang);
                  return _buildGetMaterialApp(
                      context, SelectLang, isDarkMode, allNotes);
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

  GetMaterialApp _buildGetMaterialApp(BuildContext context, String lang,
      bool isDarkMode, List<NoteModel> allNotes) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale(lang),
      title: 'Notes Recorder',
      theme: AppTheme.getTheme(isDarkMode),
      home: FutureBuilder<bool>(
        future: TutorialHelper.shouldShowTutorial(),
        builder: (context, snapshot) {
          final notesScreen = BlocBuilder<UpdateCubit, UpdateState>(
            builder: (context, state) {
              if (state is UpdateInitial) {
                return Notes(allNotes: allNotes, isDarkMode: isDarkMode);
              }
              if (state is AddNoteState) {
                return AddNote(allNotes: allNotes);
              } else if (state is UpdateNotes) {
                return Notes(allNotes: state.allNotes, isDarkMode: isDarkMode);
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );

          // If we should show the tutorial (first time)
          if (snapshot.hasData && snapshot.data == true) {
            // Wait a bit before showing tutorial to allow UI to build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              TutorialHelper.showTutorial(
                context,
                onComplete: () {
                  Get.back(); // Close tutorial and return to app
                },
              );
            });
          }

          return notesScreen;
        },
      ),
    );
  }
}

class Notes extends StatelessWidget {
  const Notes({
    super.key,
    required this.allNotes,
    required this.isDarkMode,
  });

  final List<NoteModel> allNotes;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              _NotesHeader(isDarkMode: isDarkMode),
              NotesList(allNotes: allNotes, isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
      floatingActionButton: _FloatingAddButton(allNotes: allNotes),
    );
  }
}

class _NotesHeader extends StatelessWidget {
  const _NotesHeader({
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          const AppLogo(size: 32),
          const SizedBox(width: 8),
          Row(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  log('Accessing hidden notes');
                  // Show temporary indicator to let user know something is happening
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(width: 16),
                          Text("Accessing hidden notes..."),
                        ],
                      ),
                      duration: const Duration(milliseconds: 800),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );

                  // Slight delay to ensure feedback is shown before navigating
                  Future.delayed(const Duration(milliseconds: 300), () {
                    BlocProvider.of<HideNotesCubit>(context).chechPIN();
                  });
                },
                child: Tooltip(
                  message: 'Double-tap to access hidden notes',
                  child: Text(
                    S.of(context).Notes,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Text(
                S.of(context).Recorder,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenu(isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}

class _FloatingAddButton extends StatelessWidget {
  const _FloatingAddButton({required this.allNotes});

  final List<NoteModel> allNotes;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.bottomSheet(
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading:
                        const Icon(Icons.article, color: AppTheme.primaryColor),
                    title: Text(
                      "Add A New Note",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(AddNote(
                        allNotes: allNotes,
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.assignment_turned_in,
                        color: AppTheme.primaryColor),
                    title: Text(
                      "Add A New To Do List",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(
                        const ToDo(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              )),
          enableDrag: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text("New"),
      backgroundColor: AppTheme.primaryColor,
    );
  }
}
