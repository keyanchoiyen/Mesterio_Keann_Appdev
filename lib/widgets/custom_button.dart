import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppTheme.primaryOrange,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
    );
  }
}
