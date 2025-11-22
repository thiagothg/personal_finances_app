// lib/src/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _pinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSettingPin = false; // onboarding mode: set PIN
  final bool _useConfirm = true;

  @override
  void initState() {
    super.initState();
    final state = ref.read(authControllerProvider);
    _isSettingPin = state.status == AuthStatus.onboarding;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    // If already authenticated, push to dashboard (replace)
    if (authState.status == AuthStatus.authenticated) {
      // Replace with your app's route (GoRouter or Navigator)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go('/'); // dashboard root
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Unlock')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isSettingPin ? 'Create a PIN' : 'Enter your PIN',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _pinCtrl,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: 'PIN',
                          hintText: '4-6 digit PIN',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter a PIN';
                          if (v.length < 4) return 'PIN must be at least 4 digits';
                          if (!RegExp(r'^\d+$').hasMatch(v)) return 'Only digits allowed';
                          return null;
                        },
                      ),
                      if (_isSettingPin && _useConfirm)
                        TextFormField(
                          controller: _confirmPinCtrl,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 6,
                          decoration: const InputDecoration(labelText: 'Confirm PIN'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Confirm your PIN';
                            if (v != _pinCtrl.text) return 'PINs do not match';
                            return null;
                          },
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final pin = _pinCtrl.text.trim();
                          if (_isSettingPin) {
                            await controller.setPin(pin);
                            if (!mounted) return;
                            // After setting PIN, we remain unauthenticated until user enters it or biometric auto-auth
                            setState(() => _isSettingPin = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PIN set. Please unlock.')),
                            );
                          } else {
                            final ok = await controller.submitPin(pin);
                            if (!mounted) return;
                            if (!ok) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Wrong PIN')));
                            } // on success the provider will redirect
                          }
                        },
                        child: Text(_isSettingPin ? 'Set PIN' : 'Unlock'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (authState.biometricAvailable && !_isSettingPin)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometrics'),
                    onPressed: () async {
                      final ok = await controller.authenticateBiometrics();
                      if (!mounted) return;
                      if (!ok) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Biometric auth failed')));
                      }
                    },
                  ),
                const SizedBox(height: 8),
                if (!_isSettingPin)
                  TextButton(
                    onPressed: () {
                      // provide a way to reset PIN (dangerous — for dev only)
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Reset PIN?'),
                          content: const Text(
                            'This will remove your saved PIN. Use only if you remember account details.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await ref.read(authRepositoryProvider).removePin();
                                if (!mounted) return;
                                Navigator.of(context).pop();
                                setState(() => _isSettingPin = true);
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Reset PIN'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
