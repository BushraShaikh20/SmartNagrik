class EmergencyResponseModel {
  final String id;
  final String helperId;
  final String helperName;
  final String? helperPhone;
  final String message;
  final bool shareContact;
  final DateTime createdAt;

  const EmergencyResponseModel({
    required this.id,
    required this.helperId,
    required this.helperName,
    this.helperPhone,
    required this.message,
    required this.shareContact,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'helperId': helperId,
      'helperName': helperName,
      'helperPhone': helperPhone,
      'message': message,
      'shareContact': shareContact,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmergencyResponseModel.fromMap(Map<String, dynamic> map) {
    return EmergencyResponseModel(
      id: map['id'] as String? ?? '',
      helperId: map['helperId'] as String? ?? '',
      helperName: map['helperName'] as String? ?? 'Helper',
      helperPhone: map['helperPhone'] as String?,
      message: map['message'] as String? ?? '',
      shareContact: map['shareContact'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
