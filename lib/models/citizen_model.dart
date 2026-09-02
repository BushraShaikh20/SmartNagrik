import '../core/enums/user_role.dart';
import 'user_model.dart';

class CitizenModel extends UserModel {
  final int impactPoints;
  final int reportsSubmitted;
  final int reportsResolved;
  final List<String> badges;

  const CitizenModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    super.photoUrl,
    required super.createdAt,
    super.isActive = true,
    this.impactPoints = 120,
    this.reportsSubmitted = 3,
    this.reportsResolved = 2,
    this.badges = const ['Eco Warrior', 'Active Citizen', 'City Watch'],
  }) : super(role: UserRole.citizen);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['impactPoints'] = impactPoints;
    map['reportsSubmitted'] = reportsSubmitted;
    map['reportsResolved'] = reportsResolved;
    map['badges'] = badges;
    return map;
  }

  factory CitizenModel.fromMap(Map<String, dynamic> map) {
    return CitizenModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? 'Rohan Sharma',
      email: map['email'] as String? ?? 'rohan.sharma@example.com',
      phone: map['phone'] as String? ?? '+91 98765 43210',
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
      impactPoints: (map['impactPoints'] as num?)?.toInt() ?? 120,
      reportsSubmitted: (map['reportsSubmitted'] as num?)?.toInt() ?? 3,
      reportsResolved: (map['reportsResolved'] as num?)?.toInt() ?? 2,
      badges: (map['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Eco Warrior', 'Active Citizen', 'City Watch'],
    );
  }
}
