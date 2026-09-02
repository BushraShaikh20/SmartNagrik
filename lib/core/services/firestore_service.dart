import 'package:flutter/foundation.dart';
import '../../models/analytics_model.dart';
import '../../models/emergency_model.dart';
import '../../models/emergency_response_model.dart';
import '../../models/location_model.dart';
import '../../models/report_image_model.dart';
import '../../models/report_model.dart';
import '../../models/report_timeline_model.dart';
import '../../models/task_model.dart';
import '../enums/emergency_status.dart';
import '../enums/emergency_type.dart';
import '../enums/report_priority.dart';
import '../enums/report_status.dart';
import '../enums/task_status.dart';
import '../utils/string_utils.dart';

class FirestoreService extends ChangeNotifier {
  final List<ReportModel> _reports = [];
  final List<EmergencyModel> _emergencies = [];
  final List<TaskModel> _tasks = [];

  List<ReportModel> get reports => List.unmodifiable(_reports);
  List<EmergencyModel> get emergencies => List.unmodifiable(_emergencies);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  AnalyticsModel get analytics {
    final total = _reports.length;
    final inProgress = _reports
        .where((r) =>
            r.status == ReportStatus.inProgress ||
            r.status == ReportStatus.officerAssigned)
        .length;
    final resolved = _reports
        .where((r) =>
            r.status == ReportStatus.resolved ||
            r.status == ReportStatus.closed)
        .length;
    final pending = _reports
        .where((r) =>
            r.status == ReportStatus.submitted ||
            r.status == ReportStatus.communityVerified)
        .length;

    final Map<String, int> catMap = {};
    for (var r in _reports) {
      catMap[r.category] = (catMap[r.category] ?? 0) + 1;
    }

    return AnalyticsModel(
      totalReports: total,
      pendingReports: pending,
      inProgressReports: inProgress,
      resolvedReports: resolved,
      reportsByCategory: catMap,
    );
  }

  FirestoreService() {
    _seedInitialData();
  }

  void _seedInitialData() {
    // Default 0 state for clean initial session across Citizen, Authority & Field Officer
  }

  // --- REPORT METHODS ---
  Future<String> submitReport({
    required String citizenId,
    required String citizenName,
    required String category,
    required String title,
    required String description,
    required LocationModel location,
    required List<String> imagePaths,
  }) async {
    final reportId = AppStringUtils.generateReportId();
    final now = DateTime.now();

    final newReport = ReportModel(
      id: reportId,
      citizenId: citizenId,
      citizenName: citizenName,
      category: category,
      title: title,
      description: description,
      location: location,
      images: imagePaths
          .map((p) => ReportImageModel(
                id: 'img_${DateTime.now().millisecondsSinceEpoch}_${p.hashCode}',
                url: p,
                uploadedAt: now,
              ))
          .toList(),
      status: ReportStatus.submitted,
      createdAt: now,
      updatedAt: now,
      timeline: [
        ReportTimelineModel(
          id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
          status: ReportStatus.submitted,
          title: 'Report Submitted',
          description: 'Civic issue report submitted by $citizenName.',
          timestamp: now,
          isCompleted: true,
        ),
      ],
    );

    _reports.insert(0, newReport);
    notifyListeners();
    return reportId;
  }

  void verifyReportAdmin(String reportId, {String? adminNote}) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final rep = _reports[index];
      final now = DateTime.now();
      final updatedTimeline = List<ReportTimelineModel>.from(rep.timeline)
        ..add(ReportTimelineModel(
          id: 'tl_${now.millisecondsSinceEpoch}',
          status: ReportStatus.communityVerified,
          title: 'Community Verified',
          description: adminNote ?? 'Report verified by municipal admin.',
          timestamp: now,
          isCompleted: true,
        ));

      _reports[index] = rep.copyWith(
        status: ReportStatus.communityVerified,
        adminNote: adminNote,
        updatedAt: now,
        timeline: updatedTimeline,
      );
      notifyListeners();
    }
  }

  void rejectReportAdmin(String reportId, String reason) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final rep = _reports[index];
      _reports[index] = rep.copyWith(
        status: ReportStatus.rejected,
        adminNote: reason,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void assignOfficer({
    required String reportId,
    required String officerId,
    required String officerName,
    required ReportPriority priority,
    required DateTime dueDate,
    String? note,
  }) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final rep = _reports[index];
      final now = DateTime.now();
      final updatedTimeline = List<ReportTimelineModel>.from(rep.timeline)
        ..add(ReportTimelineModel(
          id: 'tl_${now.millisecondsSinceEpoch}',
          status: ReportStatus.officerAssigned,
          title: 'Officer Assigned',
          description:
              'Assigned to $officerName. Due by ${dueDate.day}/${dueDate.month}/${dueDate.year}.',
          timestamp: now,
          isCompleted: true,
          updatedBy: 'Admin',
        ));

      _reports[index] = rep.copyWith(
        assignedOfficerId: officerId,
        assignedOfficerName: officerName,
        priority: priority,
        dueDate: dueDate,
        status: ReportStatus.officerAssigned,
        updatedAt: now,
        timeline: updatedTimeline,
      );

      // Create or update task for officer
      _tasks.insert(
        0,
        TaskModel(
          id: 'TSK-$reportId',
          reportId: reportId,
          officerId: officerId,
          officerName: officerName,
          title: '${rep.category} - ${rep.location.address}',
          description: rep.description,
          location: rep.location,
          issueImages: rep.images,
          status: TaskStatus.assigned,
          priority: priority,
          assignedAt: now,
          dueDate: dueDate,
        ),
      );

      notifyListeners();
    }
  }

  void updateTaskProgress({
    required String reportId,
    required String progressNotes,
    List<String> photoPaths = const [],
  }) {
    final now = DateTime.now();
    final repIndex = _reports.indexWhere((r) => r.id == reportId);
    if (repIndex != -1) {
      final rep = _reports[repIndex];
      final updatedTimeline = List<ReportTimelineModel>.from(rep.timeline)
        ..add(ReportTimelineModel(
          id: 'tl_${now.millisecondsSinceEpoch}',
          status: ReportStatus.inProgress,
          title: 'Work In Progress',
          description: progressNotes,
          timestamp: now,
          isCompleted: true,
          updatedBy: rep.assignedOfficerName,
        ));

      _reports[repIndex] = rep.copyWith(
        status: ReportStatus.inProgress,
        updatedAt: now,
        timeline: updatedTimeline,
      );
    }

    final taskIndex = _tasks.indexWhere((t) => t.reportId == reportId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        status: TaskStatus.inProgress,
        progressNotes: progressNotes,
        progressImages: photoPaths
            .map((p) => ReportImageModel(
                  id: 'prog_${p.hashCode}',
                  url: p,
                  uploadedAt: now,
                ))
            .toList(),
      );
    }

    notifyListeners();
  }

  void completeTask({
    required String reportId,
    required String completionNotes,
    List<String> completionImages = const [],
  }) {
    final now = DateTime.now();
    final repIndex = _reports.indexWhere((r) => r.id == reportId);
    if (repIndex != -1) {
      final rep = _reports[repIndex];
      final updatedTimeline = List<ReportTimelineModel>.from(rep.timeline)
        ..add(ReportTimelineModel(
          id: 'tl_${now.millisecondsSinceEpoch}',
          status: ReportStatus.resolved,
          title: 'Resolved',
          description: completionNotes,
          timestamp: now,
          isCompleted: true,
          updatedBy: rep.assignedOfficerName,
        ));

      _reports[repIndex] = rep.copyWith(
        status: ReportStatus.resolved,
        resolutionNote: completionNotes,
        resolutionImages: completionImages
            .map((p) => ReportImageModel(
                  id: 'comp_${p.hashCode}',
                  url: p,
                  uploadedAt: now,
                ))
            .toList(),
        updatedAt: now,
        timeline: updatedTimeline,
      );
    }

    final taskIndex = _tasks.indexWhere((t) => t.reportId == reportId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        status: TaskStatus.completed,
        completionNotes: completionNotes,
        completedAt: now,
      );
    }

    notifyListeners();
  }

  void confirmCitizenResolution(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final rep = _reports[index];
      final now = DateTime.now();
      final updatedTimeline = List<ReportTimelineModel>.from(rep.timeline)
        ..add(ReportTimelineModel(
          id: 'tl_${now.millisecondsSinceEpoch}',
          status: ReportStatus.closed,
          title: 'Citizen Verified & Closed',
          description:
              'Citizen confirmed resolution. Report successfully closed.',
          timestamp: now,
          isCompleted: true,
          updatedBy: rep.citizenName,
        ));

      _reports[index] = rep.copyWith(
        status: ReportStatus.closed,
        updatedAt: now,
        timeline: updatedTimeline,
      );
      notifyListeners();
    }
  }

  void markCitizenUnresolved(String reportId, String reason) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final rep = _reports[index];
      final now = DateTime.now();
      _reports[index] = rep.copyWith(
        status: ReportStatus.inProgress,
        resolutionNote: 'Citizen reported issue still unresolved: $reason',
        updatedAt: now,
      );
      notifyListeners();
    }
  }

  // --- EMERGENCY SOS METHODS ---
  Future<String> triggerEmergency({
    required String userId,
    required String userName,
    required String userPhone,
    required EmergencyType type,
    required String description,
    required LocationModel location,
  }) async {
    final id = 'EM${1000 + _emergencies.length + 1}';
    final emergency = EmergencyModel(
      id: id,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      type: type,
      description: description,
      location: location,
      usersNotifiedCount: 8,
      status: EmergencyStatus.active,
      createdAt: DateTime.now(),
    );

    _emergencies.insert(0, emergency);
    notifyListeners();
    return id;
  }

  void offerHelpForEmergency({
    required String emergencyId,
    required String helperId,
    required String helperName,
    String? helperPhone,
    required String message,
    required bool shareContact,
  }) {
    final index = _emergencies.indexWhere((e) => e.id == emergencyId);
    if (index != -1) {
      final em = _emergencies[index];
      final newResp = EmergencyResponseModel(
        id: 'resp_${DateTime.now().millisecondsSinceEpoch}',
        helperId: helperId,
        helperName: helperName,
        helperPhone: helperPhone,
        message: message,
        shareContact: shareContact,
        createdAt: DateTime.now(),
      );

      final updatedResponses = List<EmergencyResponseModel>.from(em.responses)
        ..add(newResp);
      _emergencies[index] = em.copyWith(
        responses: updatedResponses,
        status: EmergencyStatus.responding,
      );
      notifyListeners();
    }
  }

  void closeEmergency(String emergencyId) {
    final index = _emergencies.indexWhere((e) => e.id == emergencyId);
    if (index != -1) {
      _emergencies[index] = _emergencies[index].copyWith(
        status: EmergencyStatus.resolved,
        resolvedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
