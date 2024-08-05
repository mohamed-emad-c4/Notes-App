import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/view/more_view/Favorite.dart';
import 'package:test1/view/record_notes.dart';

import 'more_view/archive.dart';
import 'more_view/deleted.dart';
import 'more_view/setting.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Recorder',
      home: Scaffold(
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    const Text(
                      'Notes Recorder',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 10,
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'Deleted',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Deleted'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Archived',
                          child: Row(
                            children: [
                              Icon(
                                Icons.archive,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Archived'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Favorites',
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Favorites'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Settings',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Settings'),
                            ],
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == 'Deleted') {
                          Get.to(const Deleted());
                        } else if (value == 'Archived') {
                          Get.to(const Archived());
                        } else if (value == 'Favorites') {
                          Get.to(const Favorite());
                        } else if (value == 'Settings') {
                          Get.to(const Setting());
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => RecordNotes(
                        index: index,
                      ),
                  itemCount: 10),
            ]),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            onPressed: () {
              Get.snackbar(
                'title',
                'message',
                backgroundColor: Colors.grey.withOpacity(0.1),
              );
            },
            child: const Icon(Icons.mic),
          ),
        ),
      ),
    );
  }
}
