import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test1/cubit/cubit/change_lan_cubit.dart';
import 'package:test1/cubit/cubit/setting_cubit.dart';
import 'package:test1/cubit/update_cubit.dart';
import 'package:test1/generated/l10n.dart';
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
        title: Text(S.of(context).Settings),
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
  String selectedLanguage = 'en';
  int volume = 50;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    notificationsEnabled = await SharePrefrenceClass()
        .getVlue(key: 'notificationsEnabled', defaultValue: true);
    selectedLanguage = await SharePrefrenceClass()
        .getVlue(key: 'selectedLanguage', defaultValue: 'en');
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
      title: Text(S.of(context).DarkMode),
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
      title: Text(S.of(context).Language), // Use translation
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
              Get.snackbar("changed", "Restart app to see changes");
              BlocProvider.of<ChangeLanCubit>(context).changeLan();
            },
            items: <String>['en', 'ar', 'fr']
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
      title: Text(S.of(context).EnableNotifications),
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
      title: Text(S.of(context).PrivacyAndSecurity),
      onTap: () {
        Get.to(const PrivacyAndSecurityPage());
      },
    );
  }

  // Help & Support Tile
  ListTile _buildHelpTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.help),
      title: Text(S.of(context).HelpSupport),
      onTap: () {
        Get.to(const HelpAndSupportPage());
      },
    );
  }

  // About Us Tile
  ListTile _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(S.of(context).AboutUs),
      onTap: () {
        Get.to(const AboutUsPage());
      },
    );
  }
}
