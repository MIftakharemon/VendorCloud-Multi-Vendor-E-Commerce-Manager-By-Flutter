import 'dart:convert';
import 'package:get/get.dart';
import 'package:karmalab_assignment/constants/network_constants.dart';
import 'package:karmalab_assignment/controllers/base_controller.dart';
import 'package:karmalab_assignment/services/base/auth_client.dart';
import 'package:karmalab_assignment/services/shared_pref_service.dart';

import '../models/report_model.dart';

class ReportService extends BaseController {
  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();

  Future<List<Report>?> getAllReports() async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getAllReports,
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        List<dynamic> data = response['body']['data'];
        return data.map((json) => Report.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching all reports: $e');
    }
    return null;
  }

  Future<Report?> getReportById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getReportById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return Report.fromJson(response['body']['data']);
      }
    } catch (e) {
      print('Error fetching report by ID: $e');
    }
    return null;
  }

  Future<bool> createReport(dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.createReport,
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null && response['body']['status'] == 'success') {
        return true;
      }
    } catch (e) {
      print('Error creating report: $e');
    }
    return false;
  }

  Future<bool> updateReportById(String id, dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.patch(
        NetworkConstants.updateReportById(id),
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null && response['body']['status'] == 'success') {
        return true;
      }
    } catch (e) {
      print('Error updating report by ID: $e');
    }
    return false;
  }

  Future<bool> deleteReportById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteReportById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null && response['body']['status'] == 'success') {
        return true;
      }
    } catch (e) {
      print('Error deleting report by ID: $e');
    }
    return false;
  }
}
