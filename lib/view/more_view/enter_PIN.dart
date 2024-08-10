import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/view/more_view/hide_notes.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  Future<void> _checkPin() async {
    final enteredPin = _pinController.text;
    final savedPin = await _storage.read(key: 'user_pin');

    if (enteredPin == savedPin) {
      Get.off(const HiddenNotesScreen());
      // Navigate to hidden notes screen
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HiddenNotesScreen()));
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).IncorrectPIN)), // Text translated
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).Enter)), // Text translated
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: S.of(context).EnterPIN, // Text translated
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 12,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkPin,
              child: Text(S.of(context).Enter), // Text translated
            ),
          ],
        ),
      ),
    );
  }
}
