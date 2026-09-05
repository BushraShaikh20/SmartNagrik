import '../core/enums/user_role.dart';
import 'user_model.dart';

class AuthorityModel extends UserModel {
  final String departmentId;
  final String designation;
  final String jurisdiction;

  const AuthorityModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    super.photoUrl,
    required super.createdAt,
    super.isActive = true,
    required this.departmentId,
    required this.designation,
    required this.jurisdiction,
  }) : super(role: UserRole.authority);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['departmentId'] = departmentId;
    map['designation'] = designation;
    map['jurisdiction'] = jurisdiction;
    return map;
  }

  factory AuthorityModel.fromMap(Map<String, dynamic> map) {
    return AuthorityModel(
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
      designation: map['designation'] as String? ?? '',
      jurisdiction: map['jurisdiction'] as String? ?? '',
    );
  }
}
