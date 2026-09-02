import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/enums/report_priority.dart';
import 'package:smart_nagrik/core/enums/report_status.dart';
import 'package:smart_nagrik/core/enums/task_status.dart';
import 'package:smart_nagrik/core/services/report_pdf_service.dart';
import 'package:smart_nagrik/models/location_model.dart';
import 'package:smart_nagrik/models/report_model.dart';
import 'package:smart_nagrik/models/task_model.dart';

void main() {
  group('ReportPdfService Tests', () {
    test('generatePdf generates a valid document with report details', () async {
      final report = ReportModel(
        id: 'SN184152',
        citizenId: 'usr_rohan_101',
        citizenName: 'Rohan Sharma',
        category: 'Pothole',
        title: 'Main Road Damage',
        description: 'Large pothole on road.',
        location: const LocationModel(
          latitude: 21.1458,
          longitude: 79.0882,
          address: 'Civil Lines, Nagpur',
        ),
        images: [],
        status: ReportStatus.inProgress,
        priority: ReportPriority.high,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final pdfDoc = await ReportPdfService.generatePdf(report);
      final bytes = await pdfDoc.save();
      expect(bytes.isNotEmpty, true);
    });

    test('generateAnalyticsPdf generates valid city summary PDF', () async {
      final pdfDoc = await ReportPdfService.generateAnalyticsPdf(
        totalReports: 12,
        inProgress: 4,
        resolved: 6,
        pending: 2,
        reports: [],
      );
      final bytes = await pdfDoc.save();
      expect(bytes.isNotEmpty, true);
    });

    test('generateTaskCompletionPdf generates valid task certificate PDF', () async {
      final task = TaskModel(
        id: 'TSK_101',
        reportId: 'REP_505',
        officerId: 'officer_rajesh_01',
        officerName: 'Rajesh Patil',
        title: 'Repair Road Asphalt',
        description: 'Patch potholes with hot mix asphalt.',
        location: const LocationModel(
          latitude: 21.1458,
          longitude: 79.0882,
          address: 'Civil Lines, Nagpur',
        ),
        issueImages: const [],
        status: TaskStatus.completed,
        assignedAt: DateTime.now().subtract(const Duration(days: 2)),
        dueDate: DateTime.now(),
        completionNotes: 'All asphalt patches laid and leveled.',
        completedAt: DateTime.now(),
      );

      final pdfDoc = await ReportPdfService.generateTaskCompletionPdf(task: task);
      final bytes = await pdfDoc.save();
      expect(bytes.isNotEmpty, true);
    });
  });
}
