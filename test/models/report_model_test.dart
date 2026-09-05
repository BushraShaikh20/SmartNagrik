import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/enums/report_status.dart';
import 'package:smart_nagrik/models/location_model.dart';
import 'package:smart_nagrik/models/report_model.dart';

void main() {
  group('ReportModel Tests', () {
    test('toMap and fromMap serialization', () {
      final report = ReportModel(
        id: 'SN184152',
        citizenId: 'usr_rohan_101',
        citizenName: 'Rohan Sharma',
        category: 'Pothole',
        title: 'Large Pothole',
        description: 'Road damage on Civil Lines.',
        location: const LocationModel(
          latitude: 21.1458,
          longitude: 79.0882,
          address: 'Civil Lines, Nagpur',
        ),
        images: [],
        status: ReportStatus.inProgress,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final map = report.toMap();
      expect(map['id'], 'SN184152');
      expect(map['status'], 'inProgress');

      final deserialized = ReportModel.fromMap(map);
      expect(deserialized.id, report.id);
      expect(deserialized.category, 'Pothole');
      expect(deserialized.status, ReportStatus.inProgress);
    });
  });
}
