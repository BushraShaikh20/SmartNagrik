import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/report_model.dart';
import '../../models/task_model.dart';
import '../utils/date_utils.dart';

class ReportPdfService {
  // 1. Single Civic Report PDF
  static Future<pw.Document> generatePdf(ReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SMART NAGRIK',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal800,
                        ),
                      ),
                      pw.Text(
                        'Civic Issue & Municipal Action Report',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.teal50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.teal700, width: 1),
                    ),
                    child: pw.Text(
                      'REPORT #${report.id}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal900,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 12),

              // Summary Grid
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Expanded(child: _pdfMetaItem('Category', report.category)),
                        pw.Expanded(child: _pdfMetaItem('Current Status', report.status.label)),
                        pw.Expanded(child: _pdfMetaItem('Priority', report.priority.label)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _pdfMetaItem('Filed By', report.citizenName)),
                        pw.Expanded(child: _pdfMetaItem('Date Filed', AppDateUtils.formatDateTime(report.createdAt))),
                        pw.Expanded(child: _pdfMetaItem('Assigned Officer', report.assignedOfficerName ?? 'Not Assigned')),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              pw.Text('Issue Title', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text(report.title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
              pw.SizedBox(height: 10),

              pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text(report.description, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
              pw.SizedBox(height: 12),

              pw.Text('Location & Ward', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text(report.location.address, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
              pw.Text(
                'Coordinates: (${report.location.latitude.toStringAsFixed(5)}, ${report.location.longitude.toStringAsFixed(5)})',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
              pw.SizedBox(height: 16),

              if (report.resolutionNote != null && report.resolutionNote!.isNotEmpty) ...[
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(6),
                    border: pw.Border.all(color: PdfColors.green300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Officer Resolution Notes:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.green900)),
                      pw.SizedBox(height: 3),
                      pw.Text(report.resolutionNote!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
              ],

              pw.Text('Action Timeline', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 8),
              if (report.timeline.isEmpty)
                pw.Text('Report created and logged in central municipal queue.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600))
              else
                ...report.timeline.map((step) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 6,
                            height: 6,
                            margin: const pw.EdgeInsets.only(top: 3, right: 8),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.teal700,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '${step.title} (${AppDateUtils.formatDateTime(step.timestamp)})',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                                ),
                                pw.Text(step.description, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400, thickness: 0.8),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Generated by Smart Nagrik Municipal Platform', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('Official Municipal Document | Page 1 of 1', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // 2. City Municipal Analytics & Ward Summary PDF
  static Future<pw.Document> generateAnalyticsPdf({
    required int totalReports,
    required int inProgress,
    required int resolved,
    required int pending,
    required List<ReportModel> reports,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          final resolutionRate = totalReports > 0 ? ((resolved / totalReports) * 100).toStringAsFixed(1) : '0.0';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SMART NAGRIK MUNICIPAL CORPORATION',
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                      ),
                      pw.Text('City Civic Analytics & Ward Performance Report', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.blue700),
                    ),
                    child: pw.Text(
                      'STATUS: OFFICIAL AUDIT',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 12),

              // KPI Stats Grid
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfKpiCard('Total Reports', '$totalReports', PdfColors.blue800, PdfColors.blue50),
                  _pdfKpiCard('In Progress', '$inProgress', PdfColors.orange800, PdfColors.orange50),
                  _pdfKpiCard('Resolved', '$resolved', PdfColors.green800, PdfColors.green50),
                  _pdfKpiCard('Pending', '$pending', PdfColors.red800, PdfColors.red50),
                ],
              ),
              pw.SizedBox(height: 16),

              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Municipal Resolution Efficiency Rate:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text('$resolutionRate%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: PdfColors.green800)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Text('Recent Civic Issues Log', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 8),

              if (reports.isEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 20),
                  child: pw.Center(child: pw.Text('No civic reports currently registered in database.', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600))),
                )
              else
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _tableHeader('ID'),
                        _tableHeader('Category'),
                        _tableHeader('Title'),
                        _tableHeader('Status'),
                        _tableHeader('Date Filed'),
                      ],
                    ),
                    ...reports.take(8).map((r) => pw.TableRow(
                          children: [
                            _tableCell(r.id),
                            _tableCell(r.category),
                            _tableCell(r.title),
                            _tableCell(r.status.label),
                            _tableCell(AppDateUtils.formatDate(r.createdAt)),
                          ],
                        )),
                  ],
                ),

              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400, thickness: 0.8),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Generated by Smart Nagrik Municipal Authority', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('Date: ${AppDateUtils.formatDateTime(DateTime.now())}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // 3. Field Officer Task Completion Certificate PDF
  static Future<pw.Document> generateTaskCompletionPdf({
    required TaskModel task,
    ReportModel? report,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FIELD WORK COMPLETION CERTIFICATE',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.purple900),
                      ),
                      pw.Text('Municipal Engineering & Field Operations Division', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.purple50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.purple700),
                    ),
                    child: pw.Text(
                      'TASK #${task.id}',
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.purple900),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 12),

              // Officer & Task Metadata
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Expanded(child: _pdfMetaItem('Assigned Officer', task.officerName)),
                        pw.Expanded(child: _pdfMetaItem('Officer ID', task.officerId)),
                        pw.Expanded(child: _pdfMetaItem('Status', task.status.label)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Expanded(child: _pdfMetaItem('Assigned Date', AppDateUtils.formatDateTime(task.assignedAt))),
                        pw.Expanded(child: _pdfMetaItem('Completed Date', task.completedAt != null ? AppDateUtils.formatDateTime(task.completedAt!) : 'In Progress')),
                        pw.Expanded(child: _pdfMetaItem('Linked Report', task.reportId)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              pw.Text('Task Title & Scope', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text(task.title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(task.description, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
              pw.SizedBox(height: 14),

              pw.Text('Site Location', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text(task.location.address, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
              pw.Text('GPS Coordinates: (${task.location.latitude.toStringAsFixed(5)}, ${task.location.longitude.toStringAsFixed(5)})', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              pw.SizedBox(height: 16),

              if (task.completionNotes != null && task.completionNotes!.isNotEmpty) ...[
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColors.green400),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Field Completion & Verification Notes:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.green900)),
                      pw.SizedBox(height: 4),
                      pw.Text(task.completionNotes!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
              ],

              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Officer Signature:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.SizedBox(height: 16),
                      pw.Text('_________________________', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.Text(task.officerName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Authority Verification Stamp:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.SizedBox(height: 16),
                      pw.Text('_________________________', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.Text('Nagpur Municipal Corporation', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.grey400, thickness: 0.8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Generated by Smart Nagrik Field Operations Platform', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('Official Document | Page 1 of 1', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _pdfKpiCard(String title, String value, PdfColor textColor, PdfColor bg) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 8)),
    );
  }

  static pw.Widget _pdfMetaItem(String title, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
      ],
    );
  }

  // Print & Share API
  static Future<void> printReport(BuildContext context, ReportModel report) async {
    final doc = await generatePdf(report);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'SmartNagrik_Report_${report.id}.pdf',
    );
  }

  static Future<void> shareReport(BuildContext context, ReportModel report) async {
    final doc = await generatePdf(report);
    final pdfBytes = await doc.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: 'SmartNagrik_Report_${report.id}.pdf');
  }

  static Future<void> printAnalytics({
    required BuildContext context,
    required int totalReports,
    required int inProgress,
    required int resolved,
    required int pending,
    required List<ReportModel> reports,
  }) async {
    final doc = await generateAnalyticsPdf(
      totalReports: totalReports,
      inProgress: inProgress,
      resolved: resolved,
      pending: pending,
      reports: reports,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'SmartNagrik_City_Analytics.pdf',
    );
  }

  static Future<void> shareAnalytics({
    required BuildContext context,
    required int totalReports,
    required int inProgress,
    required int resolved,
    required int pending,
    required List<ReportModel> reports,
  }) async {
    final doc = await generateAnalyticsPdf(
      totalReports: totalReports,
      inProgress: inProgress,
      resolved: resolved,
      pending: pending,
      reports: reports,
    );
    final pdfBytes = await doc.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: 'SmartNagrik_City_Analytics.pdf');
  }

  static Future<void> printTaskCompletion({
    required BuildContext context,
    required TaskModel task,
    ReportModel? report,
  }) async {
    final doc = await generateTaskCompletionPdf(task: task, report: report);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'SmartNagrik_Task_${task.id}.pdf',
    );
  }

  static Future<void> shareTaskCompletion({
    required BuildContext context,
    required TaskModel task,
    ReportModel? report,
  }) async {
    final doc = await generateTaskCompletionPdf(task: task, report: report);
    final pdfBytes = await doc.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: 'SmartNagrik_Task_${task.id}.pdf');
  }
}
