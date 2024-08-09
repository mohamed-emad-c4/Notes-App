import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/cubit/setting_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/shared_prefrence.dart';
import 'package:test1/view/setting_views/about_us.dart';
import 'package:test1/view/setting_views/help_and_support.dart';
import 'package:test1/view/setting_views/privacy_and_security.dart';

class Setting extends StatelessWidget {
  final bool isDarkMode;

  const Setting({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SettingsListState(isDarkMode: isDarkMode),
    );
  }
}

class SettingsListState extends StatefulWidget {
  final bool isDarkMode;

  const SettingsListState({super.key, required this.isDarkMode});

  @override
  _SettingsListStateState createState() => _SettingsListStateState();
}

class _SettingsListStateState extends State<SettingsListState> {
  late bool isDarkMode;
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  int volume = 50;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load settings from shared preferences or another source if needed
    // For example, you can load the previous state of notifications, language, etc.
    notificationsEnabled = await SharePrefrenceClass()
        .getVlue(key: 'notificationsEnabled', defaultValue: true);
    selectedLanguage = await SharePrefrenceClass()
        .getVlue(key: 'selectedLanguage', defaultValue: 'English');
    volume =
        await SharePrefrenceClass().getVlue(key: 'volume', defaultValue: 50);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDarkModeTile(context),
        const Divider(),
        _buildLanguageTile(context),
        const Divider(),
        _buildNotificationsTile(context),
        const Divider(),
        _buildVolumeTile(context),
        const Divider(),
        _buildPrivacyTile(context),
        const Divider(),
        _buildHelpTile(context),
        const Divider(),
        _buildAboutTile(context),
      ],
    );
  }

  // Dark Mode Switch Tile
  ListTile _buildDarkModeTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Dark Mode'),
      trailing: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is UpdateSettingS) {
            // Handle any updates here if needed
          }
        },
        builder: (context, state) {
          return Switch(
            value: isDarkMode,
            onChanged: (value) async {
              await SharePrefrenceClass()
                  .saveValuebool(value: value, key: 'isDarkMode');
              log('$isDarkMode');
              setState(() {
                isDarkMode = value;
              });
              BlocProvider.of<SettingCubit>(context).UpdateSettingF();
              BlocProvider.of<UpdateCubit>(context).ChangeThemefunction();
              BlocProvider.of<UpdateCubit>(context).updateNotes();
            },
          );
        },
      ),
    );
  }

  // Language Dropdown Tile
  ListTile _buildLanguageTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text('Language'.tr), // Use translation
      trailing: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is UpdateSettingS) {
            // Handle any updates here if needed
          }
        },
        builder: (context, state) {
          return DropdownButton<String>(
            value: selectedLanguage,
            onChanged: (String? newValue) async {
              setState(() {
                selectedLanguage = newValue!;
              });
              await SharePrefrenceClass().saveValueString(
                  value: selectedLanguage, key: 'selectedLanguage');
              // Change the locale in GetX
             
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
    );
  }

  // Notifications Switch Tile
  ListTile _buildNotificationsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Enable Notifications'),
      trailing: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is UpdateSettingS) {
            // Handle any updates here if needed
          }
        },
        builder: (context, state) {
          return Switch(
            value: notificationsEnabled,
            onChanged: (value) async {
              notificationsEnabled = value;
              await SharePrefrenceClass().saveValuebool(
                  value: notificationsEnabled, key: 'notificationsEnabled');
              setState(() {});
              BlocProvider.of<SettingCubit>(context).UpdateSettingF();
            },
          );
        },
      ),
    );
  }

  // Volume Slider Tile
  ListTile _buildVolumeTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.volume_up),
      title: const Text('Volume'),
      subtitle: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is UpdateSettingS) {
            // Handle any updates here if needed
          }
        },
        builder: (context, state) {
          return Slider(
            value: volume.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: '$volume',
            onChanged: (value) async {
              volume = value.toInt();
              await SharePrefrenceClass()
                  .saveValueint(value: volume, key: 'volume');
              log(value.toString());
              setState(() {});
              BlocProvider.of<SettingCubit>(context).UpdateSettingF();
            },
          );
        },
      ),
    );
  }

  // Privacy and Security Tile
  ListTile _buildPrivacyTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: const Text('Privacy and Security'),
      onTap: () {
        // Add your navigation logic here
        Get.to(const PrivacyAndSecurityPage());
      },
    );
  }

  // Help & Support Tile
  ListTile _buildHelpTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help),
      title: const Text('Help & Support'),
      onTap: () {
        // Add your navigation logic here
        Get.to(const HelpAndSupportPage());
      },
    );
  }

  // About Us Tile
  ListTile _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('About Us'),
      onTap: () {
        Get.to(const AboutUsPage());
      },
    );
  }
}
