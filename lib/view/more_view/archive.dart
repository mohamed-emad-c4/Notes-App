import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/DB/database.dart';
import 'package:test1/cubit/cubit/cubit/archive_update_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/models/note.dart';
import 'package:test1/shared/app_theme.dart';

// Function to get the list of archived notes
Future<List<NoteModel>> getArchivedList() async {
  try {
    // Fetch archived notes from the database
    List<NoteModel> list = await NotesDatabase.instance.getAllArchivedNotes();
    return list;
  } catch (e) {
    // Handle any exceptions and return an empty list
    return [];
  }
}

// Utility function to create gradient colors
Color getDarkerShade(Color baseColor) {
  final hslColor = HSLColor.fromColor(baseColor);
  return hslColor
      .withLightness((hslColor.lightness - 0.1).clamp(0.0, 1.0))
      .toColor();
}

Color getBrighterShade(Color baseColor) {
  final hslColor = HSLColor.fromColor(baseColor);
  return hslColor
      .withSaturation((hslColor.saturation + 0.15).clamp(0.0, 1.0))
      .withLightness((hslColor.lightness + 0.1).clamp(0.0, 1.0))
      .toColor();
}

class ArchivedList extends StatefulWidget {
  const ArchivedList({super.key});

  @override
  State<ArchivedList> createState() => _ArchivedListState();
}

class _ArchivedListState extends State<ArchivedList>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _animationController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ArchiveUpdateCubit, ArchiveUpdateState>(
      builder: (context, state) {
        if (state is ArchiveUpdate || state is ArchiveUpdateInitial) {
          return Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    )
                  : Text(
                      S.of(context).ArchivedNotes,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
              centerTitle: true,
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withAlpha(25),
                    Colors.white,
                  ],
                ),
              ),
              child: FutureBuilder<List<NoteModel>>(
                future: getArchivedList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingShimmer(isDarkMode);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${S.of(context).Error}: ${snapshot.error}',
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState(context, isDarkMode);
                  } else {
                    final archivedNotes = snapshot.data!;
                    List<NoteModel> archivedNotesReversed =
                        archivedNotes.reversed.toList();

                    // Filter notes based on search query
                    if (_searchQuery.isNotEmpty) {
                      archivedNotesReversed = archivedNotesReversed
                          .where((note) =>
                              note.title
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              note.content
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                          .toList();
                    }

                    // If filtered list is empty, show no results message
                    if (archivedNotesReversed.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).NoNotesAvailable,
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 12, bottom: 24),
                        itemCount: archivedNotesReversed.length,
                        itemBuilder: (context, index) {
                          final note = archivedNotesReversed[index];
                          const baseColor = AppTheme.archivedColor;
                          final brighterColor = getBrighterShade(baseColor);

                          // Determine text colors based on theme
                          final textColor = isDarkMode
                              ? Colors.white.withOpacity(0.95)
                              : const Color.fromARGB(255, 45, 44, 44);
                          final subtitleColor = isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : const Color.fromARGB(255, 110, 108, 108);

                          // Create staggered animation for each card
                          final itemAnimation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (index / archivedNotesReversed.length)
                                    .clamp(0.0, 1.0),
                                ((index + 1) / archivedNotesReversed.length)
                                    .clamp(0.0, 1.0),
                                curve: Curves.easeInOut,
                              ),
                            ),
                          );

                          // Start the animation when building the list
                          if (!_animationController.isAnimating &&
                              !_animationController.isCompleted) {
                            _animationController.forward();
                          }

                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: itemAnimation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.3, 0),
                                    end: Offset.zero,
                                  ).animate(itemAnimation),
                                  child: child,
                                ),
                              );
                            },
                            child: Dismissible(
                              key: Key(note.id.toString()),
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) {
                                // Store local references to avoid deactivation issues
                                final noteId = note.id!;
                                final noteTitle = note.title;
                                final noteContent = note.content;
                                final noteFavorite = note.isFavorite;
                                final noteArchived = note.archived;
                                final noteCreatedTime = note.createdTime;

                                // Get cubits before operations
                                final archiveCubit =
                                    BlocProvider.of<ArchiveUpdateCubit>(
                                        context);
                                final updateCubit =
                                    BlocProvider.of<UpdateCubit>(context);

                                if (direction == DismissDirection.startToEnd) {
                                  // Add to favorites
                                  final newNote = NoteModel(
                                    id: noteId,
                                    title: noteTitle,
                                    content: noteContent,
                                    isFavorite: true,
                                    archived: noteArchived,
                                    createdTime: DateTime.now().toString(),
                                  );
                                  NotesDatabase.instance.update(newNote);
                                  archiveCubit.emit(ArchiveUpdate());
                                  updateCubit.updateNotes();
                                  Get.snackbar(
                                    S.of(context).AddedToFavorites,
                                    S.of(context).NoteAddedSuccessfully,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        Colors.green.withOpacity(0.7),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 8,
                                  );
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  // Delete
                                  final newNote = NoteModel(
                                    id: noteId,
                                    title: noteTitle,
                                    content: noteContent,
                                    isFavorite: noteFavorite,
                                    archived: false,
                                    deleted: true,
                                    createdTime: DateTime.now().toString(),
                                  );
                                  NotesDatabase.instance.update(newNote);
                                  archiveCubit.emit(ArchiveUpdate());
                                  updateCubit.updateNotes();
                                  Get.snackbar(
                                    S.of(context).AddedToDeleted,
                                    S.of(context).NoteAddedSuccessfully,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.7),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 8,
                                  );
                                }
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.favoriteColor.withOpacity(0.8),
                                      AppTheme.favoriteColor,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        color: Colors.white, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      S.of(context).Favorite,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade300,
                                      Colors.red.shade700,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      S.of(context).Deleted,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.delete,
                                        color: Colors.white, size: 28),
                                  ],
                                ),
                              ),
                              child: Card(
                                elevation: 6,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shadowColor: Colors.black.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.3)
                                        : baseColor.withOpacity(0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [brighterColor, baseColor],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: brighterColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: -2,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                note.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(0, 1),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            _buildPopupMenu(
                                                context,
                                                archivedNotesReversed,
                                                index,
                                                isDarkMode),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: Text(
                                            note.content,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: subtitleColor,
                                                  height: 1.3,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              BlocProvider.of<UpdateCubit>(
                                                      context)
                                                  .formatDateTime(
                                                      note.createdTime),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: subtitleColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.white
                                                        .withOpacity(0.2)
                                                    : Colors.black
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.archive,
                                                    size: 14,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    S.of(context).Archived,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 64,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).NoArchivedNotesAvailable,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPopupMenu(BuildContext context, List<NoteModel> archivedNotes,
      int index, bool isDarkMode) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert,
          color: isDarkMode ? Colors.white : Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 10),
      color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'Deleted',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: 20,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              const SizedBox(width: 10),
              Text(
                S.of(context).Deleted,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Favorites',
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                size: 20,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                S.of(context).Favorite,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Unarchived',
          child: Row(
            children: [
              Icon(
                Icons.unarchive,
                size: 20,
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              const SizedBox(width: 10),
              Text(
                S.of(context).Unarchived,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        // Store local references to avoid deactivation issues
        final note = archivedNotes[index];
        final noteId = note.id;
        final noteTitle = note.title;
        final noteContent = note.content;
        final noteFavorite = note.isFavorite;

        // Get cubits before operations
        final archiveCubit = BlocProvider.of<ArchiveUpdateCubit>(context);
        final updateCubit = BlocProvider.of<UpdateCubit>(context);

        if (value == 'Deleted') {
          final newNote = NoteModel(
            id: noteId,
            title: noteTitle,
            content: noteContent,
            isFavorite: noteFavorite,
            deleted: true,
            archived: false,
            createdTime: DateTime.now().toString(),
          );
          NotesDatabase.instance.update(newNote);
          archiveCubit.emit(ArchiveUpdate());
          updateCubit.updateNotes();

          Get.snackbar(
            S.of(context).AddedToDeleted,
            S.of(context).NoteAddedSuccessfully,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
        } else if (value == 'Unarchived') {
          final newNote = NoteModel(
            id: noteId,
            title: noteTitle,
            content: noteContent,
            isFavorite: noteFavorite,
            archived: false,
            createdTime: DateTime.now().toString(),
          );
          NotesDatabase.instance.update(newNote);
          archiveCubit.emit(ArchiveUpdate());
          updateCubit.updateNotes();

          Get.snackbar(
            S.of(context).Unarchived,
            S.of(context).NoteAddedSuccessfully,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.7),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
        } else if (value == 'Favorites') {
          final newNote = NoteModel(
            id: noteId,
            title: noteTitle,
            content: noteContent,
            isFavorite: true,
            archived: note.archived,
            createdTime: DateTime.now().toString(),
          );
          NotesDatabase.instance.update(newNote);
          archiveCubit.emit(ArchiveUpdate());
          updateCubit.updateNotes();

          Get.snackbar(
            S.of(context).AddedToFavorites,
            S.of(context).NoteAddedSuccessfully,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
        }
      },
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: MediaQuery.of(context).size.height * 0.22,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Colors.grey[800]!, Colors.grey[700]!]
                    : [Colors.grey[300]!, Colors.grey[200]!],
              ),
            ),
            child: _buildShimmerEffect(isDarkMode),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.archive_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).NoArchivedNotesAvailable,
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: Text(S.of(context).Close),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
