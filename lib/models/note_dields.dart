class NoteFields {
  static const String tableName = 'notes';
  static const String id = '_id';
  static const String title = 'title';
  static const String content = 'content';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';
  static const String archived = 'archived';
  static const String deleted = 'deleted';



  static final List<String> values = [
    id,
    title,
    content,
    isFavorite,
    createdTime,
    archived,
    deleted
  ];
}