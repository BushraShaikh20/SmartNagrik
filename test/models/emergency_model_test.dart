import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/enums/emergency_status.dart';
import 'package:smart_nagrik/core/enums/emergency_type.dart';
import 'package:smart_nagrik/models/emergency_model.dart';
import 'package:smart_nagrik/models/location_model.dart';

void main() {
  group('EmergencyModel Tests', () {
    test('Serialization and status verification', () {
      final emergency = EmergencyModel(
        id: 'EM1001',
        userId: 'usr_rohan_101',
        userName: 'Rohan Sharma',
        userPhone: '+91 98765 43210',
        type: EmergencyType.medical,
        description: 'Medical distress',
        location: const LocationModel(
          latitude: 21.1458,
          longitude: 79.0882,
          address: 'Nagpur',
        ),
        createdAt: DateTime.now(),
      );

      final map = emergency.toMap();
      expect(map['id'], 'EM1001');
      expect(map['type'], 'medical');

      final deserialized = EmergencyModel.fromMap(map);
      expect(deserialized.id, 'EM1001');
      expect(deserialized.status, EmergencyStatus.active);
    });
  });
}
