import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test1/generated/l10n.dart';
import 'package:test1/shared/app_theme.dart';
import 'package:test1/view/more_view/hide_notes.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final int _pinLength = 6;
  String _pin = '';
  String _errorText = '';
  bool _isLoading = false;

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
        _pinController.text = _pin;
        _errorText = '';
      });

      // When pin is complete, verify automatically
      if (_pin.length == _pinLength) {
        _checkPin();
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

  Future<void> _checkPin() async {
    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final enteredPin = _pin;
      final savedPin = await _storage.read(key: 'user_pin');

      if (enteredPin == savedPin) {
        Get.off(const HiddenNotesScreen());
      } else {
        setState(() {
          _errorText = "Incorrect PIN. Please try again.";
          _pin = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = "An error occurred. Please try again.";
        _pin = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppTheme.getGradientAppBar(
        S.of(context).Enter,
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
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Enter your 6-digit PIN to unlock",
                            style: TextStyle(
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
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
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 40),
              // Keypad
              Expanded(
                child: !_isLoading
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              child: const Text('0',
                                  style: TextStyle(fontSize: 24)),
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
                      )
                    : Container(),
              ),
              // Forgotten PIN
              if (!_isLoading)
                TextButton.icon(
                  onPressed: () {
                    // Show reset PIN dialog or navigate to reset PIN screen
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Reset PIN"),
                        content: const Text(
                          "If you forgot your PIN, you'll need to create a new one. This will remove all your hidden notes.",
                          style: TextStyle(fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Clear PIN and navigate back
                              _storage.delete(key: 'user_pin');
                              Navigator.pop(context);
                              Get.back();
                            },
                            child: const Text("Reset",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline, size: 18),
                  label: const Text("Forgot PIN?"),
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
