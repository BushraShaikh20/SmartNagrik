import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders and handles tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Submit',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Submit'), findsOneWidget);
    await tester.tap(find.text('Submit'));
    expect(tapped, true);
  });
}
