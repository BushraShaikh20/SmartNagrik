class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String departmentId;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.departmentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'departmentId': departmentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String? ?? '',
      departmentId: map['departmentId'] as String? ?? '',
    );
  }
}
