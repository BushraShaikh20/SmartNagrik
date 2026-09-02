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
      fullName: map['fullName'] as String? ?? 'Admin Officer',
      email: map['email'] as String? ?? 'admin@smartnagrik.gov.in',
      phone: map['phone'] as String? ?? '+91 98000 11122',
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
      departmentId: map['departmentId'] as String? ?? 'MUNICIPAL_CORP',
      designation: map['designation'] as String? ?? 'Municipal Commissioner',
      jurisdiction: map['jurisdiction'] as String? ?? 'Nagpur Municipal Area',
    );
  }
}
