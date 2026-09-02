import '../core/enums/user_role.dart';
import 'user_model.dart';

class FieldOfficerModel extends UserModel {
  final String departmentId;
  final String departmentName;
  final int activeTasks;
  final int completedTasks;
  final double rating;

  const FieldOfficerModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    super.photoUrl,
    required super.createdAt,
    super.isActive = true,
    required this.departmentId,
    required this.departmentName,
    this.activeTasks = 3,
    this.completedTasks = 24,
    this.rating = 4.8,
  }) : super(role: UserRole.fieldOfficer);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['departmentId'] = departmentId;
    map['departmentName'] = departmentName;
    map['activeTasks'] = activeTasks;
    map['completedTasks'] = completedTasks;
    map['rating'] = rating;
    return map;
  }

  factory FieldOfficerModel.fromMap(Map<String, dynamic> map) {
    return FieldOfficerModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? 'Rajesh Patil',
      email: map['email'] as String? ?? 'rajesh.patil@smartnagrik.gov.in',
      phone: map['phone'] as String? ?? '+91 98222 33445',
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
      departmentId: map['departmentId'] as String? ?? 'ROAD_MAINTENANCE',
      departmentName: map['departmentName'] as String? ?? 'Roads & Infrastructure',
      activeTasks: (map['activeTasks'] as num?)?.toInt() ?? 3,
      completedTasks: (map['completedTasks'] as num?)?.toInt() ?? 24,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
    );
  }
}
