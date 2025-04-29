import 'package:get/get.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();
  final reports = <Report>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    fetchReports();
    super.onInit();
  }

  Future<void> fetchReports() async {
    isLoading(true);
    try {
      final fetchedReports = await _reportService.getAllReports();
      if (fetchedReports != null) {
        reports.assignAll(fetchedReports);
      }
    } catch (e) {
      print('Error fetching reports: $e');
    } finally {
      isLoading(false);
    }
  }
}
