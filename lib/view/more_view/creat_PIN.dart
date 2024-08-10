import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/view/more_view/enter_PIN.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  _CreatePinScreenState createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  Future<void> _savePin() async {
    final pin = _pinController.text;
    if (pin.length == 12) {
      await _storage.write(key: 'user_pin', value: pin);
      // Navigate to another screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).PINSaved)), // Text translated
      );
      Get.off(const EnterPinScreen());
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).PINMustBe12Digits)), // Text translated
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).CreatePIN)), // Text translated
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: S.of(context).EnterPIN, // Text translated
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 12,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              child: Text(S.of(context).Save), // Text translated
            ),
          ],
        ),
      ),
    );
  }
}
