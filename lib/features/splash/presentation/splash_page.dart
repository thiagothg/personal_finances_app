import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/auth_state.dart';
import '../../../shared/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _checkAuth);
  }

  void _checkAuth() {
    if (!mounted) return;
    final authState = ref.read(authControllerProvider);
    _navigateBasedOnStatus(authState.status);
  }

  void _navigateBasedOnStatus(AuthStatus status) {
    if (status == AuthStatus.authenticated) {
      context.go('/dashboard'); // shell route
    } else if (status == AuthStatus.unauthenticated || status == AuthStatus.onboarding) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status != next.status) {
        _navigateBasedOnStatus(next.status);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'Personal Finances',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
      ),
    );
  }
}
