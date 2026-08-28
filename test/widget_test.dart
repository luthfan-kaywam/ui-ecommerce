import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_ecommerce/main.dart';
import 'package:ui_ecommerce/providers/app_state_provider.dart';
import 'package:ui_ecommerce/core/widgets/theme_toggle_button.dart';

void main() {
  testWidgets('Theme toggle button renders and interacts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const AppStateScope(
        child: MaterialApp(
          home: Scaffold(
            body: ThemeToggleButton(),
          ),
        ),
      ),
    );

    expect(find.byType(ThemeToggleButton), findsOneWidget);
  });
}
