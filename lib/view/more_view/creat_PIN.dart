// creat_PIN.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN Saved')));
      Get.to(const EnterPinScreen());
    } else {
      // Show error
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN must be 12 digits')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                  labelText: 'Enter 6-digit PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 12,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              child: const Text('Save PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
