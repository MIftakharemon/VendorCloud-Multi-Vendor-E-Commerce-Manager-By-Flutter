import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iconsax/iconsax.dart';

class VendorManagementScreen extends StatelessWidget {
  final List<TipData> tips = [
    TipData(
      title: "High-Quality Images",
      what: "Upload clear, professional-grade images with transparent backgrounds",
      why: "High-quality visuals grab customer attention and build trust",
      extra: "Showcase multiple angles and close-up details",
      icon: Iconsax.gallery,
      color: Colors.blue,
    ),
    TipData(
      title: "Detailed Descriptions",
      what: "Include size, material, color, features, and usage instructions",
      why: "Customers rely on descriptions to make purchase decisions",
      extra: "Use bullet points for scannable content",
      icon: Iconsax.document_text,
      color: Colors.purple,
    ),
    TipData(
      title: "Competitive Pricing",
      what: "Research competitors and provide better price or added value",
      why: "Customers compare prices before purchasing",
      extra: "Run limited-time discounts or bundle offers",
      icon: Iconsax.money,
      color: Colors.green,
    ),
    TipData(
      title: "Keyword Optimization",
      what: "Use relevant searchable keywords in product titles",
      why: "Optimized titles improve search visibility",
      extra: "Check app's search trends regularly",
      icon: Iconsax.search_normal,
      color: Colors.orange,
    ),
    TipData(
      title: "Fast Shipping",
      what: "Partner with reliable logistics providers",
      why: "Customers prioritize faster delivery",
      extra: "Highlight delivery timelines prominently",
      icon: Iconsax.truck_fast,
      color: Colors.red,
    ),
    // Add remaining tips similarly
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Vendor Success Guide',
              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              speed: Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return _buildTipCard(tips[index], index);
        },
      ),
    );
  }

  Widget _buildTipCard(TipData tip, int index) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(tip.icon, color: tip.color, size: 28),
          title: Text(
            tip.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: tip.color,
            ),
          ),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection("What to do:", tip.what, tip.color),
                SizedBox(height: 12),
                _buildSection("Why it matters:", tip.why, tip.color),
                SizedBox(height: 12),
                _buildSection("Pro tip:", tip.extra, tip.color),
              ],
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slideX(begin: 0.2, end: 0, duration: 500.ms);
  }

  Widget _buildSection(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

class TipData {
  final String title;
  final String what;
  final String why;
  final String extra;
  final IconData icon;
  final Color color;

  TipData({
    required this.title,
    required this.what,
    required this.why,
    required this.extra,
    required this.icon,
    required this.color,
  });
}
