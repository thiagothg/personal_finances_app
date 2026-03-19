import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/login_provider.dart';
import '../../providers/biometric_auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  Future<void> _submitLogin() async {
    setState(() {
      _isEmailValid = _validateEmail(_emailController.text);
      _isPasswordValid = _validatePassword(_passwordController.text);
    });

    if (!_isEmailValid || !_isPasswordValid) {
      return;
    }

    final success = await ref
        .read(loginControllerProvider.notifier)
        .login(_emailController.text, _passwordController.text);

    if (success && mounted) {
      context.go('/'); // Navigate to dashboard
    }
  }

  Future<void> _submitBiometricLogin() async {
    final success = await ref.read(biometricAuthControllerProvider.notifier).authenticate();

    if (success && mounted) {
      context.go('/'); // Navigate to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        final errorMsg = next.error
            .toString()
            .replaceFirst('Exception: ', '')
            .replaceAll('ArgumentError: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final loginState = ref.watch(loginControllerProvider);
    final biometricState = ref.watch(biometricAuthControllerProvider);

    final isBiometricAvailable = biometricState.maybeWhen(
      data: (available) => available,
      orElse: () => false,
    );

    final loginForm = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Title
              Text(
                'Personal Finances',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your finances easily',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'your@email.com',
                  errorText: !_isEmailValid ? 'Invalid email format' : null,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    _isEmailValid = _validateEmail(value);
                  });
                },
              ),
              const SizedBox(height: 16),

              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: !_isPasswordValid ? 'Min. 6 characters' : null,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: !_showPassword,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = _validatePassword(value);
                  });
                },
                onSubmitted: (_) => _submitLogin(),
              ),
              const SizedBox(height: 8),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot password feature coming soon')),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 16),

              // Error Message
              if (loginState.hasError && !loginState.isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SelectableText.rich(
                    TextSpan(
                      text:
                          'Login failed: ${loginState.error.toString().replaceFirst('Exception: ', '').replaceAll('ArgumentError: ', '')}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              // Login Button
              ElevatedButton(
                onPressed: loginState.isLoading ? null : _submitLogin,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: loginState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 24),

              // Divider
              if (isBiometricAvailable)
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('OR', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    Expanded(child: Container(height: 1, color: Colors.grey[300])),
                  ],
                ),
              const SizedBox(height: 24),

              // Biometric Button (if available)
              if (isBiometricAvailable)
                OutlinedButton.icon(
                  onPressed: biometricState.isLoading ? null : _submitBiometricLogin,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Use Biometric'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return loginForm;
          }
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: const Center(
                    child: Icon(Icons.account_balance_wallet, size: 100, color: Colors.white),
                  ),
                ),
              ),
              Expanded(flex: 1, child: loginForm),
            ],
          );
        },
      ),
    );
  }
}
