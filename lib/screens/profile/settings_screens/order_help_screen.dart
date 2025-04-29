import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/sizes.dart';

class OrderHelpScreen extends StatelessWidget {
  const OrderHelpScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    await _launchUrl(phoneUri);
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello, I need assistance with ',
    );
    await _launchUrl(emailUri);
  }

  Future<void> _openMessenger() async {
    const String fbProfileId = '';
    final Uri webUri = Uri.parse('https://m.me/61569352619463');
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'Help & Support',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.5,
        onPressed: () => _showQuickHelpDialog(context),
        child: const Icon(Iconsax.message_question5, color: Colors.white, size: 22),
        backgroundColor: Colors.blue[400],
      ).animate().scale(delay: 500.ms),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            RoundedContainer(
              padding: const EdgeInsets.all(Sizes.md),
              backgroundColor: Colors.white,
              showBorder: true,
              borderColor: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.message_question, color: Colors.blue[400] ?? Colors.blue, size: 20)
                          .animate()
                          .shake(delay: 1000.ms),
                      const SizedBox(width: Sizes.sm),
                      Text(
                        'Frequently Asked Questions',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  _buildExpandableFAQ(
                    'How do I list new products?',
                    'Go to your vendor dashboard, click "Upload Product" and fill in all required details including high-quality images, detailed descriptions, and accurate pricing.',
                    Colors.indigo[400] ?? Colors.indigo,
                  ),
                  _buildExpandableFAQ(
                    'How are payments processed?',
                    'Payments are processed every 7 days for verified vendors. Funds are transferred directly to your registered bank account.',
                    Colors.teal[400] ?? Colors.teal,
                  ),
                  _buildExpandableFAQ(
                    'How can I improve my store visibility?',
                    'Keep your product listings updated, maintain high ratings, respond to customer queries promptly, and participate in platform promotions.',
                    Colors.purple[400] ?? Colors.purple,
                  ),
                  _buildExpandableFAQ(
                    'How do I participate in events?',
                    'Access the Event Management Section in your Dashboard to join upcoming sales events and seasonal promotions.',
                    Colors.orange[400] ?? Colors.orange,
                  ),
                  _buildExpandableFAQ(
                    'How can I advertise my products?',
                    'Visit the Ad Management Section to create and manage promotional campaigns.',
                    Colors.pink[400] ?? Colors.pink,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(),

            const SizedBox(height: Sizes.spaceBtwSections),

            RoundedContainer(
              padding: const EdgeInsets.all(Sizes.md),
              backgroundColor: Colors.white,
              showBorder: true,
              borderColor: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.support, color: Colors.green[400] ?? Colors.green, size: 20)
                          .animate()
                          .shake(delay: 1500.ms),
                      const SizedBox(width: Sizes.sm),
                      Text(
                        'Contact Support',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  _buildAnimatedContactItem(
                    Iconsax.call,
                    'Call Us',
                    '01748614424',
                    Colors.blue[400] ?? Colors.blue,
                        () => _showContactDialog(context, 'Call Support'),
                  ),
                  _buildAnimatedContactItem(
                    Iconsax.message,
                    'Email Support',
                    'info@readyhow.com',
                    Colors.green[400] ?? Colors.green,
                        () => _showContactDialog(context, 'Email Support'),
                  ),
                  _buildAnimatedContactItem(
                    Iconsax.message_question,
                    'Live Chat',
                    'Available 24/7',
                    Colors.orange[400] ?? Colors.orange,
                        () => _showContactDialog(context, 'Live Chat'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(),
          ],
        ),
      ),
    );
  }
  Widget _buildExpandableFAQ(String question, String answer, Color accentColor) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        title: Text(
          question,
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              answer,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ),
        ],
        iconColor: accentColor,
        collapsedIconColor: Colors.grey[400],
        backgroundColor: Colors.grey[50],
        collapsedBackgroundColor: Colors.white,
      ).animate().fadeIn(),
    );
  }

  Widget _buildAnimatedContactItem(
      IconData icon,
      String title,
      String detail,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color)
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(delay: 2000.ms, duration: 1200.ms),
            const SizedBox(width: Sizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.titleSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    detail,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
        ),
        title: Row(
          children: [
            Icon(
              type == 'Call Support'
                  ? Iconsax.call
                  : type == 'Email Support'
                  ? Iconsax.message
                  : Iconsax.message_question,
              color: type == 'Call Support'
                  ? Colors.blue[400]
                  : type == 'Email Support'
                  ? Colors.green[400]
                  : Colors.orange[400],
            ),
            const SizedBox(width: Sizes.sm),
            Text(type),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              type == 'Call Support'
                  ? 'Our support team is available Monday to Friday, 9 AM to 6 PM EST.'
                  : type == 'Email Support'
                  ? 'We typically respond to emails within 24 hours.'
                  : 'Connect with our support team instantly through live chat.',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                try {
                  if (type == 'Call Support') {
                    _makePhoneCall('01748614424');
                  } else if (type == 'Email Support') {
                    _sendEmail('info@readyhow.com');
                  } else {
                    _openMessenger();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not open ${type.toLowerCase()}. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Icon(
                type == 'Call Support'
                    ? Iconsax.call
                    : type == 'Email Support'
                    ? Iconsax.message
                    : Iconsax.message_question,
              ),
              label: Text(
                type == 'Call Support'
                    ? 'Call Now'
                    : type == 'Email Support'
                    ? 'Send Email'
                    : 'Start Chat',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: type == 'Call Support'
                    ? Colors.blue[400]
                    : type == 'Email Support'
                    ? Colors.green[400]
                    : Colors.orange[400],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
        ),
        title: Row(
          children: [
            Icon(Iconsax.support, color: Colors.blue[400]),
            const SizedBox(width: Sizes.sm),
            const Text('Need Quick Help?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Our support team is ready to assist you 24/7. Choose your preferred way to connect with us.',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _openMessenger();
              },
              icon: const Icon(Iconsax.message_text),
              label: const Text('Start Live Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
