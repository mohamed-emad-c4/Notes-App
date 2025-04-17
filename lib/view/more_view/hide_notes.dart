import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:test1/DB/hide.dart'; // Import your database class
import 'package:test1/cubit/hide_cubit_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder(
        bloc: BlocProvider.of<HideCubitCubit>(context),
        builder: (context, state) {
          if (state is HideCubitInitial || state is HideCubitUpdated) {
            return Scaffold(
              appBar: AppTheme.getGradientAppBar(
                S.of(context).HiddenNotes,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.lock, color: Colors.white),
                    onPressed: () {
                      // Lock functionality if needed
                    },
                  ),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder<List<NoteModel>>(
                  future: _fetchHiddenNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.withOpacity(0.8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).Error,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState(context);
                    } else {
                      final notes = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 16.0, right: 16.0),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: RecordNotesHide(
                                allNotes: notes,
                                index: index,
                                isDarkMode: isDarkMode,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              floatingActionButton: AppTheme.getFloatingActionButton(
                onPressed: () async {
                  Get.to(
                    AddHideNote(allNotes: const []),
                    duration: AppTheme.defaultAnimationDuration,
                  );
                },
                icon: const Icon(Icons.add),
                label: S.of(context).AddNote,
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      "Loading...",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTheme.gradientContainer(
            borderRadius: BorderRadius.circular(50),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.lock_outline,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).NoHiddenNotesFound,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0),
            child: Text(
              "Your protected notes will appear here. Tap + to add a hidden note",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(
                AddHideNote(allNotes: const []),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(S.of(context).AddNote),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
