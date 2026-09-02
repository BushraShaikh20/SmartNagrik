class ReportImageModel {
  final String id;
  final String url;
  final String? caption;
  final DateTime uploadedAt;

  const ReportImageModel({
    required this.id,
    required this.url,
    this.caption,
    required this.uploadedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'caption': caption,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory ReportImageModel.fromMap(Map<String, dynamic> map) {
    return ReportImageModel(
      id: map['id'] as String? ?? '',
      url: map['url'] as String? ?? '',
      caption: map['caption'] as String?,
      uploadedAt: map['uploadedAt'] != null
          ? DateTime.tryParse(map['uploadedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
