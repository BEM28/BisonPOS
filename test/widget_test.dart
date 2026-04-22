import 'package:flutter_test/flutter_test.dart';
import 'package:bison_pos/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BisonPosApp());

    // Verify that our app starts on the InitialRoutingScreen
    expect(find.text('Bison POS Selection'), findsOneWidget);
    expect(find.text('Login Staff (POS)'), findsOneWidget);
  });
}
