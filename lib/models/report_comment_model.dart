class ReportCommentModel {
  final String id;
  final String userId;
  final String userName;
  final String userRole;
  final String message;
  final DateTime createdAt;

  const ReportCommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReportCommentModel.fromMap(Map<String, dynamic> map) {
    return ReportCommentModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      userRole: map['userRole'] as String? ?? 'Citizen',
      message: map['message'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
