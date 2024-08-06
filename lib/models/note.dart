import 'package:test1/models/note_dields.dart';

class NoteModel {
  final int? id;
  final String title;
  final String content;
  bool isFavorite;
  final String createdTime;
  bool archived = false;
  bool deleted = false;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.isFavorite = false,
    required this.createdTime,
    this.archived = false,
    this.deleted = false,
  });

  Map<String, dynamic> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.isFavorite: isFavorite ? 1 : 0,
        NoteFields.archived: archived ? 1 : 0,
        NoteFields.deleted: deleted ? 1 : 0,
        NoteFields.createdTime: createdTime,
      };

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        isFavorite: json[NoteFields.isFavorite] == 1,
        archived: json[NoteFields.archived] == 1,
        deleted: json[NoteFields.deleted] == 1,
        createdTime: (json[NoteFields.createdTime] as String),
      );

  NoteModel CopyWith({
    int? id,
    String? title,
    String? content,
    bool? isFavorite,
    bool? archived,
    bool? deleted,
    String? createdTime,
  }) =>
      NoteModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        isFavorite: isFavorite ?? this.isFavorite,
        archived: archived ?? this.archived,
        deleted: deleted ?? this.deleted,
        createdTime: createdTime ?? this.createdTime,
      );
}