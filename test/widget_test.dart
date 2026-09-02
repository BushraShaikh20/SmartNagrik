import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/app.dart';

void main() {
  testWidgets('App loads and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartNagrikApp());
    expect(find.text('Smart Nagrik'), findsWidgets);
    
    // Advance timer past splash screen duration
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
