import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<Map<String, dynamic>> tasks = [
    {'task': '', 'isDone': false}, // نبدأ بـ Checkbox واحد
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('To Do'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {
                setState(() {
                  tasks.add({'task': '', 'isDone': false});
                });
              },
              child: const Text(
                'Add A New Task',
                style: TextStyle(color: Colors.white),
              )),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    value: tasks[index]['isDone'],
                    onChanged: (bool? newValue) {
                      setState(() {
                        tasks[index]['isDone'] = newValue!;
                      });
                    },
                  ),
                  title: TextFormField(
                    initialValue: tasks[index]['task'],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter task',
                    ),
                    onChanged: (value) {
                      setState(() {
                        tasks[index]['task'] = value;
                        if (value.isEmpty) {
                          tasks.removeAt(index);
                        }
                      });
                    },
                    // تنسيق النص بناءً على حالة الـ checkbox
                    style: TextStyle(
                      decoration: tasks[index]['isDone']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    onFieldSubmitted: (value) {
                      if (index == tasks.length - 1 && value.isNotEmpty) {
                        setState(
                          () {
                            tasks.add(
                              {'task': '', 'isDone': false},
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
