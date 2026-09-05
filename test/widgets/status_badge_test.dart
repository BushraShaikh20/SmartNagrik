import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/enums/report_status.dart';
import 'package:smart_nagrik/core/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(status: ReportStatus.inProgress),
        ),
      ),
    );

    expect(find.text('In Progress'), findsOneWidget);
  });
}
