import 'package:flutter/material.dart';

class Archived extends StatefulWidget {
  const Archived({super.key});

  @override
  _ArchivedState createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  // بيانات الملاحظات المؤرشفة. يمكنك استبدالها ببيانات حقيقية من قاعدة البيانات.
  List<Map<String, dynamic>> archivedNotes = [
    {
      'title': 'Old Meeting Notes',
      'content': 'Review the project goals and milestones.',
      'date': '2024-07-15'
    },
    {
      'title': 'Annual Report',
      'content': 'Summary of the year\'s performance.',
      'date': '2024-06-30'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
        centerTitle: true,
        backgroundColor: Colors.teal, // تغيير لون AppBar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: archivedNotes.length,
        itemBuilder: (context, index) {
          final note = archivedNotes[index];
          return Dismissible(
            key: Key(note['title']), // مفتاح مميز لكل عنصر
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // إعادة الملاحظة إلى المفضلة
                _addNoteToFavorites(index);
              } else if (direction == DismissDirection.endToStart) {
                // حذف الملاحظة
                _deleteArchivedNote(index);
              }
            },
            background: Container(
              color: Colors.blue, // لون إعادة المفضلة
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.favorite, color: Colors.white),
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
                      Icons.archive,
                      color: Colors.teal,
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

  // إضافة الملاحظة إلى المفضلة
  void _addNoteToFavorites(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Note "${archivedNotes[index]['title']}" added to favorites!'),
        backgroundColor: Colors.blue,
      ),
    );
    setState(() {
      // يمكنك إضافة منطق لإعادة الملاحظة إلى المفضلة هنا
      archivedNotes.removeAt(index);
    });
  }

  // حذف الملاحظة
  void _deleteArchivedNote(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${archivedNotes[index]['title']}" deleted!'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      archivedNotes.removeAt(index);
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
