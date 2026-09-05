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
    this.activeTasks = 0,
    this.completedTasks = 0,
    this.rating = 0,
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
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
      departmentId: map['departmentId'] as String? ?? '',
      departmentName: map['departmentName'] as String? ?? '',
      activeTasks: (map['activeTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (map['completedTasks'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
