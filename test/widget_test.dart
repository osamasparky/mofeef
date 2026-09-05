import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modeef/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ModeefApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ModeefApp), findsOneWidget);
  });
}
