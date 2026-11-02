import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onFinished});
  final VoidCallback? onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) widget.onFinished?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryOrange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 116,
                height: 116,
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 66,
                  color: AppTheme.primaryOrange,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'CAMPUS LOST & FOUND',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Find it. Return it.',
                style: TextStyle(
                  color: AppTheme.lightYellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
