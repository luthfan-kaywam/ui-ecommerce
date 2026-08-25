import 'package:flutter_test/flutter_test.dart';
import 'package:ui_ecommerce/main.dart';
import 'package:ui_ecommerce/providers/app_state_provider.dart';

void main() {
  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    // Build our app wrapped in AppStateScope
    await tester.pumpWidget(
      const AppStateScope(
        child: MyApp(),
      ),
    );

    // Trigger frame
    await tester.pumpAndSettle();

    // Verify app title or main UI element exists
    expect(find.byType(MyApp), findsOneWidget);
  });
}
