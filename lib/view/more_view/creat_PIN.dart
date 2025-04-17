import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/shared/app_theme.dart';
import 'package:test1/view/more_view/enter_PIN.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  _CreatePinScreenState createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final int _pinLength = 6;
  String _pin = '';
  bool _confirmMode = false;
  String _firstPin = '';
  String _errorText = '';

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
        _pinController.text = _pin;
      });

      // When pin is complete, handle confirmation
      if (_pin.length == _pinLength) {
        if (!_confirmMode) {
          // First entry complete - move to confirm
          setState(() {
            _firstPin = _pin;
            _pin = '';
            _confirmMode = true;
            _errorText = '';
          });
        } else {
          // Confirm entry complete - verify match
          _verifyAndSavePin();
        }
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _pinController.text = _pin;
        _errorText = '';
      });
    }
  }

  void _clearPin() {
    setState(() {
      _pin = '';
      _pinController.text = '';
      _errorText = '';
    });
  }

  Future<void> _verifyAndSavePin() async {
    if (_pin == _firstPin) {
      await _storage.write(key: 'user_pin', value: _pin);
      AppTheme.showSnackBar(
        title: S.of(context).Success,
        message: S.of(context).PINSaved,
      );
      Get.off(const EnterPinScreen());
    } else {
      setState(() {
        _errorText = "PINs don't match. Try again.";
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppTheme.getGradientAppBar(
        _confirmMode ? "Confirm PIN" : S.of(context).CreatePIN,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // PIN status indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppTheme.gradientContainer(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _confirmMode ? Icons.shield : Icons.lock_outline,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _confirmMode
                                ? "Enter PIN again to confirm"
                                : "Create a secure 6-digit PIN",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // PIN display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pinLength,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < _pin.length
                          ? AppTheme.primaryColor
                          : isDark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              if (_errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorText,
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              // Keypad
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      // Clear button
                      return NumPadButton(
                        onPressed: _clearPin,
                        child: const Icon(Icons.clear),
                      );
                    } else if (index == 10) {
                      // 0 button
                      return NumPadButton(
                        onPressed: () => _addDigit('0'),
                        child: const Text('0', style: TextStyle(fontSize: 24)),
                      );
                    } else if (index == 11) {
                      // Backspace button
                      return NumPadButton(
                        onPressed: _removeDigit,
                        child: const Icon(Icons.backspace_outlined),
                      );
                    } else {
                      // Number buttons 1-9
                      final number = index + 1;
                      return NumPadButton(
                        onPressed: () => _addDigit(number.toString()),
                        child: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumPadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const NumPadButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
