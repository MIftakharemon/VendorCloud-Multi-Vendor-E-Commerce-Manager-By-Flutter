import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/report/report_details.dart';
import '../../controllers/report_controller.dart';
import '../../models/report_model.dart';

class AllReports extends StatelessWidget {
  static const routeName = "/allReports";
  final ReportController reportController = Get.put(ReportController());

  AllReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (reportController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (reportController.reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.report_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No reports found', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        } else {
          return ListView.separated(
            itemCount: reportController.reports.length,
            separatorBuilder: (context, index) => Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              Report report = reportController.reports[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: report.image != null
                      ? NetworkImage("https://readyhow.com${report.image!.secureUrl!}")
                      : null,
                  child: report.image == null
                      ? Icon(Icons.image_not_supported, color: Colors.grey)
                      : null,
                ),
                title: Text(
                  report.title ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    report.message ?? 'No content available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Get.to(
                      () => ReportDetailScreen(report: report),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 700),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
