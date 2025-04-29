import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/event_ad_management_package_controller.dart';
import '../../models/event_model.dart';
import '../../models/pachakge_model.dart';
import '../../models/product_model.dart';
import '../../utils/constants/colors.dart';
import '../eventAdManager/event_ad_product_screen.dart';

class Package_EventScreen extends GetView<GenericController> {
  final bool isPackageScreen;
  static const packageRouteName = "/package";
  static const eventRouteName = "/event";

  const Package_EventScreen({Key? key, this.isPackageScreen = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = isPackageScreen
        ? Get.find<GenericController<Package>>(tag: 'package')
        : Get.find<GenericController<Event>>(tag: 'event');

    controller.fetchItems();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            isPackageScreen ? 'Ad Packages' : 'Events',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ).animate().fadeIn(duration: Duration(milliseconds: 600)),
      ),
      body: Obx(
        () => controller.isLoading.value && controller.items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: ScrollController()
                  ..addListener(() {
                    if (ScrollController().position.pixels ==
                        ScrollController().position.maxScrollExtent) {
                      if (!controller.isLoading.value &&
                          controller.hasMoreData) {
                        controller.fetchItems(isLoadMore: true);
                      }
                    }
                  }),
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.items.length) {
                    return controller.isLoading.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  return _buildPackageCard(controller.items[index])
                      .animate()
                      .fadeIn(
                        duration: Duration(milliseconds: 1200),
                        delay: Duration(milliseconds: 100 * index),
                        curve: Curves.easeOutQuart,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: Duration(milliseconds: 1200),
                        delay: Duration(milliseconds: 100 * index),
                        curve: Curves.easeOutQuart,
                      );
                },
              ),
      ),
    );
  }

  Widget _buildPackageCard(dynamic package) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPackageHeader(package),
              _buildPackageDetails(package),
              if (isPackageScreen &&
                  (package.packageProducts?.isNotEmpty ?? false))
                _buildPackageProductsList(package.packageProducts!)
              else if (!isPackageScreen &&
                  (package.eventProducts?.isNotEmpty ?? false))
                _buildEventProductsList(package.eventProducts!),
              _buildActionButton(package),
            ],
          )),
    );
  }

  Widget _buildPackageHeader(dynamic package) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              package.name ?? 'Unnamed Package',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildStatusBadge(package.status ?? 'inactive'),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'inactive':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.capitalize ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPackageDetails(dynamic item) {
    final formatter = NumberFormat.currency(symbol: '৳', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isPackageScreen) ...[
            _buildInfoRow(
              'Duration',
              '${item.duration} days',
              Icons.timer_outlined,
            ),
          ] else ...[
            _buildInfoRow(
              'Start Date',
              _formatDate(item.startDate),
              Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'End Date',
              _formatDate(item.endDate),
              Icons.event_outlined,
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            'Price',
            formatter.format(isPackageScreen
                ? (item.price ?? 0)
                : double.parse(item.price ?? '0')),
            Icons.attach_money,
          ),
          if (isPackageScreen) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              'Max Products',
              '${item.maxProduct}',
              Icons.inventory_2_outlined,
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            'Created',
            _formatDate(item.createdAt),
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageProductsList(List<PackageProducts> products) {
    return _buildGenericProductsList(
      products: products,
      title: 'Package Products',
      getProduct: (item) => item.product,
    );
  }

  Widget _buildEventProductsList(List<EventProducts> products) {
    return _buildGenericProductsList(
      products: products,
      title: 'Event Products',
      getProduct: (item) => item.product,
    );
  }

  Widget _buildGenericProductsList<T>({
    required List<T> products,
    required String title,
    required Product? Function(T) getProduct,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '$title (',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '${products.length}',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
                const TextSpan(
                  text: ')',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = getProduct(products[index]);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                  child: Card(
                    color: AppColors.white,
                    margin: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 200,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product?.coverPhoto != null
                                ? Image.network(
                                    product!.coverPhoto!,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 44,
                                        height: 44,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 44,
                                        height: 44,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 44,
                                    height: 44,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product?.name ?? 'Unnamed Product',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 50 * index),
                      curve: Curves.easeOutQuart,
                    )
                    .slideX(
                      begin: 0.3,
                      end: 0,
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 50 * index),
                      curve: Curves.easeOutQuart,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(dynamic item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() =>
              Event_AD_Products(isPackage: isPackageScreen, id: item.sId));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 45),
        ),
        child: Text(isPackageScreen ? 'Select Package' : 'Join'),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
}
