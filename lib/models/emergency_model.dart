import '../core/enums/emergency_status.dart';
import '../core/enums/emergency_type.dart';
import 'emergency_response_model.dart';
import 'location_model.dart';

class EmergencyModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final EmergencyType type;
  final String description;
  final LocationModel location;
  final bool isLocationSharingActive;
  final EmergencyStatus status;
  final int usersNotifiedCount;
  final List<EmergencyResponseModel> responses;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const EmergencyModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.type,
    required this.description,
    required this.location,
    this.isLocationSharingActive = true,
    this.status = EmergencyStatus.active,
    this.usersNotifiedCount = 8,
    this.responses = const [],
    required this.createdAt,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'type': type.name,
      'description': description,
      'location': location.toMap(),
      'isLocationSharingActive': isLocationSharingActive,
      'status': status.name,
      'usersNotifiedCount': usersNotifiedCount,
      'responses': responses.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  factory EmergencyModel.fromMap(Map<String, dynamic> map) {
    return EmergencyModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Citizen',
      userPhone: map['userPhone'] as String? ?? '',
      type: EmergencyType.fromString(map['type'] as String?),
      description: map['description'] as String? ?? '',
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
          : const LocationModel(
              latitude: 21.1458,
              longitude: 79.0882,
              address: 'Civil Lines, Nagpur',
            ),
      isLocationSharingActive: map['isLocationSharingActive'] as bool? ?? true,
      status: EmergencyStatus.fromString(map['status'] as String?),
      usersNotifiedCount: (map['usersNotifiedCount'] as num?)?.toInt() ?? 8,
      responses: (map['responses'] as List<dynamic>?)
              ?.map((x) => EmergencyResponseModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.tryParse(map['resolvedAt'].toString())
          : null,
    );
  }

  EmergencyModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    EmergencyType? type,
    String? description,
    LocationModel? location,
    bool? isLocationSharingActive,
    EmergencyStatus? status,
    int? usersNotifiedCount,
    List<EmergencyResponseModel>? responses,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return EmergencyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      type: type ?? this.type,
      description: description ?? this.description,
      location: location ?? this.location,
      isLocationSharingActive:
          isLocationSharingActive ?? this.isLocationSharingActive,
      status: status ?? this.status,
      usersNotifiedCount: usersNotifiedCount ?? this.usersNotifiedCount,
      responses: responses ?? this.responses,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
