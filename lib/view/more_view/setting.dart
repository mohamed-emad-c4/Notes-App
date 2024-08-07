import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/cubit/cubit/setting_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SettingsListState(),
    );
  }
}

class SettingsListState extends StatelessWidget {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  int volume = 50;

  SettingsListState({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Dark Mode'),
          trailing: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is UpdateSettingS) {}
            },
            builder: (context, state) {
              return Switch(
                value: isDarkMode,
                onChanged: (value) {
                  log('$isDarkMode');
                  isDarkMode = value;
                  BlocProvider.of<SettingCubit>(context).UpdateSettingF();
                  BlocProvider.of<UpdateCubit>(context).ChangeThemefunction();

                  BlocProvider.of<UpdateCubit>(context).updateNotes();
                },
              );
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is UpdateSettingS) {}
            },
            builder: (context, state) {
              return DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  selectedLanguage = newValue!;
                  BlocProvider.of<SettingCubit>(context).UpdateSettingF();
                },
                items: <String>['English', 'Arabic', 'French']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Enable Notifications'),
          trailing: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is UpdateSettingS) {}
            },
            builder: (context, state) {
              return Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  notificationsEnabled = value;
                  BlocProvider.of<SettingCubit>(context).UpdateSettingF();
                },
              );
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.volume_up),
          title: const Text('Volume'),
          subtitle: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is UpdateSettingS) {}
            },
            builder: (context, state) {
              return Slider(
                value: volume.toDouble(),
                min: 0,
                max: 100,
                divisions: 10,
                label: '$volume',
                onChanged: (value) {
                  volume = value.toInt();
                  log(value.toString());
                  BlocProvider.of<SettingCubit>(context).UpdateSettingF();
                },
              );
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Privacy and Security'),
          onTap: () {
            // Add your navigation logic here
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            // Add your navigation logic here
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About Us'),
          onTap: () {
            // Add your navigation logic here
          },
        ),
      ],
    );
  }
}
