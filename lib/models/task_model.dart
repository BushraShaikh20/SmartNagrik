import '../core/enums/report_priority.dart';
import '../core/enums/task_status.dart';
import 'location_model.dart';
import 'report_image_model.dart';

class TaskModel {
  final String id;
  final String reportId;
  final String officerId;
  final String officerName;
  final String title;
  final String description;
  final LocationModel location;
  final List<ReportImageModel> issueImages;
  final TaskStatus status;
  final ReportPriority priority;
  final DateTime assignedAt;
  final DateTime dueDate;
  final String? progressNotes;
  final List<ReportImageModel> progressImages;
  final String? completionNotes;
  final List<ReportImageModel> completionImages;
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    required this.reportId,
    required this.officerId,
    required this.officerName,
    required this.title,
    required this.description,
    required this.location,
    required this.issueImages,
    required this.status,
    this.priority = ReportPriority.medium,
    required this.assignedAt,
    required this.dueDate,
    this.progressNotes,
    this.progressImages = const [],
    this.completionNotes,
    this.completionImages = const [],
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reportId': reportId,
      'officerId': officerId,
      'officerName': officerName,
      'title': title,
      'description': description,
      'location': location.toMap(),
      'issueImages': issueImages.map((x) => x.toMap()).toList(),
      'status': status.name,
      'priority': priority.name,
      'assignedAt': assignedAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'progressNotes': progressNotes,
      'progressImages': progressImages.map((x) => x.toMap()).toList(),
      'completionNotes': completionNotes,
      'completionImages': completionImages.map((x) => x.toMap()).toList(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String? ?? '',
      reportId: map['reportId'] as String? ?? '',
      officerId: map['officerId'] as String? ?? '',
      officerName: map['officerName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
          : const LocationModel(
              latitude: 21.1458,
              longitude: 79.0882,
              address: 'Civil Lines, Nagpur',
            ),
      issueImages: (map['issueImages'] as List<dynamic>?)
              ?.map((x) => ReportImageModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      status: TaskStatus.fromString(map['status'] as String?),
      priority: ReportPriority.fromString(map['priority'] as String?),
      assignedAt: map['assignedAt'] != null
          ? DateTime.tryParse(map['assignedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now().add(const Duration(days: 3)),
      progressNotes: map['progressNotes'] as String?,
      progressImages: (map['progressImages'] as List<dynamic>?)
              ?.map((x) => ReportImageModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      completionNotes: map['completionNotes'] as String?,
      completionImages: (map['completionImages'] as List<dynamic>?)
              ?.map((x) => ReportImageModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'].toString())
          : null,
    );
  }

  TaskModel copyWith({
    String? id,
    String? reportId,
    String? officerId,
    String? officerName,
    String? title,
    String? description,
    LocationModel? location,
    List<ReportImageModel>? issueImages,
    TaskStatus? status,
    ReportPriority? priority,
    DateTime? assignedAt,
    DateTime? dueDate,
    String? progressNotes,
    List<ReportImageModel>? progressImages,
    String? completionNotes,
    List<ReportImageModel>? completionImages,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      officerId: officerId ?? this.officerId,
      officerName: officerName ?? this.officerName,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      issueImages: issueImages ?? this.issueImages,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedAt: assignedAt ?? this.assignedAt,
      dueDate: dueDate ?? this.dueDate,
      progressNotes: progressNotes ?? this.progressNotes,
      progressImages: progressImages ?? this.progressImages,
      completionNotes: completionNotes ?? this.completionNotes,
      completionImages: completionImages ?? this.completionImages,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
