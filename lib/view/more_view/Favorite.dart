import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  // بيانات الملاحظات المفضلة. يمكنك استبدالها ببيانات حقيقية من قاعدة البيانات.
  List<Map<String, dynamic>> favoriteNotes = [
    {
      'title': 'Shopping List',
      'content': 'Buy milk, eggs, and bread.',
      'date': '2024-08-01'
    },
    {
      'title': 'Meeting Notes',
      'content': 'Discuss project roadmap and deadlines.',
      'date': '2024-08-02'
    },
    {
      'title': 'Holiday Plan',
      'content': 'Visit Egypt, explore Cairo, and enjoy the beach.',
      'date': '2024-08-03'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Notes'),
        centerTitle: true,
        backgroundColor: Colors.teal, // تغيير لون AppBar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = favoriteNotes[index];
          return Dismissible(
            key: Key(note['title']), // مفتاح مميز لكل عنصر
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // أرشفة الملاحظة
                _archiveNote(note);
              } else if (direction == DismissDirection.endToStart) {
                // إزالة الملاحظة من المفضلة
                _removeNoteFromFavorites(index);
              }
            },
            background: Container(
              color: Colors.green, // لون الأرشفة
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.archive, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red, // لون الحذف
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              elevation: 3, // إضافة ظل للكارد
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  note['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  note['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note['date'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // الإجراء الذي يحدث عند الضغط على الملاحظة
                  _showNoteDetails(context, note);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // أرشفة الملاحظة
  void _archiveNote(Map<String, dynamic> note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note['title']}" archived!'),
        backgroundColor: Colors.blue,
      ),
    );
    // يمكنك إضافة منطق الأرشفة هنا
  }

  // إزالة الملاحظة من قائمة المفضلات
  void _removeNoteFromFavorites(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Note "${favoriteNotes[index]['title']}" removed from favorites!'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      favoriteNotes.removeAt(index);
    });
  }

  // نافذة منبثقة لعرض تفاصيل الملاحظة
  void _showNoteDetails(BuildContext context, Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note['title']),
          content: Text(note['content']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}
