class DepartmentModel {
  final String id;
  final String name;
  final String icon;
  final String contactEmail;
  final String contactPhone;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.contactEmail,
    required this.contactPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String? ?? '',
      contactEmail: map['contactEmail'] as String? ?? '',
      contactPhone: map['contactPhone'] as String? ?? '',
    );
  }
}
