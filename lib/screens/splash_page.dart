import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.goNamed(AppRoutes.overview);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D2A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF123752), Color(0xFF0B1D2A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_movies_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'dibuat oleh rendy',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
