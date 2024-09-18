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
import 'package:test1/view/more_view/creat_PIN.dart';
import 'package:test1/view/more_view/enter_PIN.dart';
import 'package:test1/widgets/Notes.dart';


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


