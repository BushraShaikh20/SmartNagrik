import '../core/enums/report_status.dart';

class ReportTimelineModel {
  final String id;
  final ReportStatus status;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;
  final String? updatedBy;

  const ReportTimelineModel({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
    this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.name,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'isCompleted': isCompleted,
      'updatedBy': updatedBy,
    };
  }

  factory ReportTimelineModel.fromMap(Map<String, dynamic> map) {
    return ReportTimelineModel(
      id: map['id'] as String? ?? '',
      status: ReportStatus.fromString(map['status'] as String?),
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isCompleted: map['isCompleted'] as bool? ?? false,
      updatedBy: map['updatedBy'] as String?,
    );
  }
}
