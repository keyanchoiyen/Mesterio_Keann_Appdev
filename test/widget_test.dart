import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_lost_found/main.dart';
import 'package:campus_lost_found/theme/app_theme.dart';

void main() {
  testWidgets(
    'application builds with Campus Lost & Found branding and theme',
    (tester) async {
      await tester.pumpWidget(const CampusLostFoundApp());
      await tester.pump(const Duration(milliseconds: 1900));
      expect(find.byType(CampusLostFoundApp), findsOneWidget);
      expect(AppTheme.primaryOrange, const Color(0xFFF57C00));
      expect(AppTheme.background, const Color(0xFFFFF9EF));
    },
  );
}
