import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About Application',
                subtitle: 'Learn about Campus Lost & Found',
                onTap: () => _showInfo(
                  context,
                  'About Application',
                  'Campus Lost & Found helps campus community members report and recover lost items.\n\nFind it. Return it.',
                ),
              ),
              const Divider(indent: 68, height: 1),
              _SettingsTile(
                icon: Icons.app_settings_alt_outlined,
                title: 'Application Information',
                subtitle: 'Version and local storage details',
                onTap: () => _showInfo(
                  context,
                  'Application Information',
                  'Name: Campus Lost & Found\nVersion: 1.0.0\nPlatform: Android\nStorage: Local device',
                ),
              ),
              const Divider(indent: 68, height: 1),
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                title: 'Developer Information',
                subtitle: 'Application developer details',
                onTap: () => _showInfo(
                  context,
                  'Developer Information',
                  'Campus Lost & Found\nDeveloped with Flutter and Dart',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  void _showInfo(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.lightYellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppTheme.primaryOrange),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(subtitle),
  );
}
