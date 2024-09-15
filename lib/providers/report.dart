import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/report.dart';
import 'package:admin_app/pages/settings/services/report.dart';
import 'package:intl/intl.dart';

class ReportState {
  final Report? report;
  final bool isLoading;
  final String? errorMessage;

  ReportState({
    this.report,
    this.isLoading = false,
    this.errorMessage,
  });

  ReportState copyWith({
    Report? report,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReportState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  final ReportDataService _reportDataService;

  ReportNotifier(this._reportDataService) : super(ReportState());

  // Function to fetch report data
  Future<void> fetchReport(DateTimeRange? selectedDateRange) async {
    if (selectedDateRange == null) return;

    // state = state.copyWith(isLoading: true);
    print('startDate');

    try {
      final startDate = DateFormat('yyyy-MM-dd').format(selectedDateRange.start);
      final endDate = DateFormat('yyyy-MM-dd').format(selectedDateRange.end);
    print(startDate);
    print(endDate);

      final reportData = await _reportDataService.fetchReportData(
          startDate: startDate, endDate: endDate, languageCode: 'en');

      state = state.copyWith(report: reportData, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

// Provider for the ReportNotifier
final reportNotifierProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  final reportDataService = ReportDataService();
  return ReportNotifier(reportDataService);
});
