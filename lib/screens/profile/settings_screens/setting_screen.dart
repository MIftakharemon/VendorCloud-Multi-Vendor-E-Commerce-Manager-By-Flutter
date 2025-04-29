import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/profile/settings_screens/veondor_management_tips.dart';
import 'order_help_screen.dart';

class SettingsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              shrinkWrap: true,
              children: [
                _buildAnimatedTile(
                  'Help & Support',
                  Icons.help_outline,
                      () => Get.to(() => OrderHelpScreen()),

                ),
                _buildAnimatedTile(
                  'Vendor Management Tips',
                  Icons.business,
                      () => Get.to(() => VendorManagementScreen()),

                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTile(String title, IconData icon, VoidCallback onTap, {int delay = 0}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 0.5,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 6),  // Reduced vertical margin
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),  // Reduced padding
          leading: Icon(icon, size: 24),  // Smaller icon
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,  // Smaller font
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),  // Smaller arrow
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),  // Smaller border radius
          ),
        ),
      ),
    );
  }
}
