import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/report_model.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildSection('Message', report.message),
                  const SizedBox(height: 24),
                  _buildSection('Description', report.description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 340.0,
      floating: false,
      pinned: true,
      flexibleSpace: SafeArea(
        child: FlexibleSpaceBar(
          background: report.image?.secureUrl != null
              ? Image.network(
            "https://readyhow.com${report.image!.secureUrl!}",
            fit: BoxFit.cover,
          )
              : Container(
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.fingerprint, 'Report ID', report.id ?? 'N/A'),
          const Divider(height: 24),
          _buildInfoRow(Icons.shopping_bag, 'Product ID', report.productId ?? 'N/A'),
          const Divider(height: 24),
          _buildInfoRow(Icons.person, 'User ID', report.userId ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24, color: Colors.blue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 12),
        Text(
          content ?? 'No content',
          style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
        ),
      ],
    );
  }
}
