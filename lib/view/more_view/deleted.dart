import 'package:flutter/material.dart';

class Deleted extends StatelessWidget {
  const Deleted({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات الملاحظات المحذوفة. يمكنك استبدالها ببيانات حقيقية من قاعدة البيانات.
    final List<Map<String, dynamic>> deletedNotes = [
      {
        'title': 'Old Shopping List',
        'content': 'Buy apples, bananas, and oranges.',
        'date': '2024-07-25'
      },
      {
        'title': 'Old Meeting Notes',
        'content': 'Review past project deliverables.',
        'date': '2024-07-28'
      },
      {
        'title': 'Old Holiday Plan',
        'content': 'Visit France, explore Paris, and enjoy the countryside.',
        'date': '2024-07-30'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Notes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent, // تغيير لون AppBar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deletedNotes.length,
        itemBuilder: (context, index) {
          final note = deletedNotes[index];
          return Dismissible(
            key: Key(note['title']), // مفتاح مميز لكل عنصر
            // تحديد اتجاه الحذف أو الأرشفة
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // حذف الملاحظة بشكل دائم
                _deleteNotePermanently(context, note);
                deletedNotes.removeAt(index);
              } else if (direction == DismissDirection.startToEnd) {
                // أرشفة الملاحظة
                _archiveNote(context, note);
                deletedNotes.removeAt(index);
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
                      Icons.delete,
                      color: Colors.grey,
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
                style: TextStyle(color: Colors.redAccent), // تغيير لون النص
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // استعادة الملاحظة
                _restoreNote(context, note);
              },
              child: const Text(
                'Restore',
                style: TextStyle(color: Colors.green), // تغيير لون النص
              ),
            ),
          ],
        );
      },
    );
  }

  // استعادة الملاحظة
  void _restoreNote(BuildContext context, Map<String, dynamic> note) {
    // يمكنك إضافة منطق لاستعادة الملاحظة هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note['title']}" restored!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // حذف الملاحظة بشكل دائم
  void _deleteNotePermanently(BuildContext context, Map<String, dynamic> note) {
    // يمكنك إضافة منطق لحذف الملاحظة بشكل دائم هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note['title']}" deleted permanently!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // أرشفة الملاحظة
  void _archiveNote(BuildContext context, Map<String, dynamic> note) {
    // يمكنك إضافة منطق لأرشفة الملاحظة هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note "${note['title']}" archived!'),
        backgroundColor: Colors.blue, // لون الرسالة
      ),
    );
  }
}
