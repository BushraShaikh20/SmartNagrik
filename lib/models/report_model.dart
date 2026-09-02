import '../core/enums/report_priority.dart';
import '../core/enums/report_status.dart';
import 'location_model.dart';
import 'report_image_model.dart';
import 'report_timeline_model.dart';

class ReportModel {
  final String id;
  final String citizenId;
  final String citizenName;
  final String category;
  final String title;
  final String description;
  final LocationModel location;
  final List<ReportImageModel> images;
  final ReportStatus status;
  final ReportPriority priority;
  final String? assignedOfficerId;
  final String? assignedOfficerName;
  final DateTime? dueDate;
  final String? adminNote;
  final String? resolutionNote;
  final List<ReportImageModel> resolutionImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ReportTimelineModel> timeline;

  const ReportModel({
    required this.id,
    required this.citizenId,
    required this.citizenName,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.images,
    required this.status,
    this.priority = ReportPriority.medium,
    this.assignedOfficerId,
    this.assignedOfficerName,
    this.dueDate,
    this.adminNote,
    this.resolutionNote,
    this.resolutionImages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.timeline = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'citizenId': citizenId,
      'citizenName': citizenName,
      'category': category,
      'title': title,
      'description': description,
      'location': location.toMap(),
      'images': images.map((x) => x.toMap()).toList(),
      'status': status.name,
      'priority': priority.name,
      'assignedOfficerId': assignedOfficerId,
      'assignedOfficerName': assignedOfficerName,
      'dueDate': dueDate?.toIso8601String(),
      'adminNote': adminNote,
      'resolutionNote': resolutionNote,
      'resolutionImages': resolutionImages.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'timeline': timeline.map((x) => x.toMap()).toList(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String? ?? '',
      citizenId: map['citizenId'] as String? ?? '',
      citizenName: map['citizenName'] as String? ?? 'Citizen',
      category: map['category'] as String? ?? 'Pothole',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
          : const LocationModel(
              latitude: 21.1458,
              longitude: 79.0882,
              address: 'Civil Lines, Nagpur',
            ),
      images: (map['images'] as List<dynamic>?)
              ?.map((x) => ReportImageModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      status: ReportStatus.fromString(map['status'] as String?),
      priority: ReportPriority.fromString(map['priority'] as String?),
      assignedOfficerId: map['assignedOfficerId'] as String?,
      assignedOfficerName: map['assignedOfficerName'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString())
          : null,
      adminNote: map['adminNote'] as String?,
      resolutionNote: map['resolutionNote'] as String?,
      resolutionImages: (map['resolutionImages'] as List<dynamic>?)
              ?.map((x) => ReportImageModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      timeline: (map['timeline'] as List<dynamic>?)
              ?.map((x) => ReportTimelineModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  ReportModel copyWith({
    String? id,
    String? citizenId,
    String? citizenName,
    String? category,
    String? title,
    String? description,
    LocationModel? location,
    List<ReportImageModel>? images,
    ReportStatus? status,
    ReportPriority? priority,
    String? assignedOfficerId,
    String? assignedOfficerName,
    DateTime? dueDate,
    String? adminNote,
    String? resolutionNote,
    List<ReportImageModel>? resolutionImages,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReportTimelineModel>? timeline,
  }) {
    return ReportModel(
      id: id ?? this.id,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      images: images ?? this.images,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedOfficerId: assignedOfficerId ?? this.assignedOfficerId,
      assignedOfficerName: assignedOfficerName ?? this.assignedOfficerName,
      dueDate: dueDate ?? this.dueDate,
      adminNote: adminNote ?? this.adminNote,
      resolutionNote: resolutionNote ?? this.resolutionNote,
      resolutionImages: resolutionImages ?? this.resolutionImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeline: timeline ?? this.timeline,
    );
  }
}
