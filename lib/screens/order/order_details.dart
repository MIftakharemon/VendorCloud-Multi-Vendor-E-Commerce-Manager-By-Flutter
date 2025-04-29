import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:karmalab_assignment/models/order_model.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';
import 'package:karmalab_assignment/utils/constants/sizes.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../controllers/order_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  final orderController = Get.find<OrderController>();
  final Rx<String> currentStatus;

  OrderDetailsScreen({Key? key, required this.order})
      : currentStatus = (order.status ?? 'pending').obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final String shortOrderId = order.sId?.substring(order.sId!.length - 6) ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '#$shortOrderId',
              style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
// In the build method, update the SingleChildScrollView's child:

        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: Sizes.spaceBtwSections),
              _buildOrderTimeline().animate()
                  .fadeIn(
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
              )
                  .slideY(
                begin: 0.5,
                end: 0,
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderStatusCard().animate()
                        .fadeIn(
                      delay: Duration(milliseconds: 400),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    )
                        .slideY(
                      begin: 0.5,
                      end: 0,
                      delay: Duration(milliseconds: 400),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    _buildProductDetails().animate()
                        .fadeIn(
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    )
                        .slideY(
                      begin: 0.5,
                      end: 0,
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    _buildShippingDetails().animate()
                        .fadeIn(
                      delay: Duration(milliseconds: 1200),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    )
                        .slideY(
                      begin: 0.5,
                      end: 0,
                      delay: Duration(milliseconds: 1200),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    _buildPaymentSummary().animate()
                        .fadeIn(
                      delay: Duration(milliseconds: 1600),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    )
                        .slideY(
                      begin: 0.5,
                      end: 0,
                      delay: Duration(milliseconds: 1600),
                      duration: Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildOrderTimeline() {
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: Sizes.lg, horizontal: Sizes.lg),
      margin: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),


              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      orderController.updateOrderStatusById(order.sId!, 'approved');
                      currentStatus.value = 'pending';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      orderController.updateOrderStatusById(order.sId!, 'cancelled');
                      currentStatus.value = 'cancelled';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),])




              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey.shade300),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Obx(() => DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       value: currentStatus.value,
              //       items: const [
              //         DropdownMenuItem(
              //           value: 'pending',
              //           child: Text('Processing'),
              //         ),
              //         DropdownMenuItem(
              //           value: 'shipped',
              //           child: Text('Shipped'),
              //         ),
              //         DropdownMenuItem(
              //           value: 'completed',
              //           child: Text('Completed'),
              //         ),
              //       ],
              //       onChanged: (String? newStatus) async {
              //         if (newStatus != null && newStatus != currentStatus.value) {
              //           orderController.updateOrderStatusById(order.sId!, newStatus);
              //           currentStatus.value = newStatus;
              //         }
              //       },
              //     ),
              //   )),
              // ),
            ],
          ),
          const SizedBox(height: 20),

          TimelineTile(
            isFirst: true,
            endChild: _buildTimelineChild(
              'Order Placed',
              true,
              'Your order has been placed successfully',
              order.formattedOrderDate ?? '',
              Iconsax.shopping_cart,
            ),
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 3,
            ),
            indicatorStyle: IndicatorStyle(
              width: 25,
              height: 25,
              indicator: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.shopping_cart,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),

          Obx(() => TimelineTile(
            endChild: _buildTimelineChild(
              'Processing',
              currentStatus.value == 'pending',
              'Your order is being processed',
              'Estimated processing time: 1-2 days',
              Iconsax.box,
            ),
            beforeLineStyle: LineStyle(
              color: currentStatus.value == 'pending'||currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                  ? Colors.green
                  : Colors.grey.shade300,
              thickness: 3,
            ),
            indicatorStyle: IndicatorStyle(
              width: 25,
              height: 25,
              indicator: Container(
                decoration: BoxDecoration(
                  color: currentStatus.value == 'pending'||currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                      ? Colors.green
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.box,
                  color: currentStatus.value == 'pending'||currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                      ? Colors.white
                      : Colors.grey.shade400,
                  size: 15,
                ),
              ),
            ),
          )),

          Obx(() => TimelineTile(
            endChild: _buildTimelineChild(
              'Shipped',
              currentStatus.value == 'shipped',
              'Your order is on the way',
              'Package in transit',
              Iconsax.truck,
            ),
            beforeLineStyle: LineStyle(
              color: currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                  ? Colors.green
                  : Colors.grey.shade300,
              thickness: 3,
            ),
            indicatorStyle: IndicatorStyle(
              width: 25,
              height: 25,
              indicator: Container(
                decoration: BoxDecoration(
                  color: currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                      ? Colors.green
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.truck,
                  color: currentStatus.value == 'shipped' || currentStatus.value == 'completed'
                      ? Colors.white
                      : Colors.grey.shade400,
                  size: 15,
                ),
              ),
            ),
          )),

          Obx(() => TimelineTile(
            isLast: true,
            endChild: _buildTimelineChild(
              'Completed',
              currentStatus.value == 'completed',
              'Your order has been delivered',
              currentStatus.value == 'completed'
                  ? 'Delivered successfully'
                  : 'Pending delivery',
              Iconsax.verify,
            ),
            beforeLineStyle: LineStyle(
              color: currentStatus.value == 'completed'
                  ? Colors.green
                  : Colors.grey.shade300,
              thickness: 3,
            ),
            indicatorStyle: IndicatorStyle(
              width: 25,
              height: 25,
              indicator: Container(
                decoration: BoxDecoration(
                  color: currentStatus.value == 'completed'
                      ? Colors.green
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.verify,
                  color: currentStatus.value == 'completed'
                      ? Colors.white
                      : Colors.grey.shade400,
                  size: 15,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Obx(() => RoundedContainer(
      padding: const EdgeInsets.all(Sizes.md),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Status',
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Sizes.xs),
                  Text(
                    _getOrderStatusText(currentStatus.value),
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: Sizes.iconLg,
              ),
            ],
          ),
          const Divider(height: Sizes.lg),
          Text(
            'Last Updated: ${order.formattedDeliveryDate}',
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    ));
  }
  Widget _buildTimelineChild(String title, bool isActive, String description, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.lg, vertical: Sizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleSmall?.copyWith(
              color: isActive ? AppColors.primary : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: Sizes.xs),
          Text(
            description,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: Sizes.xs),
          Text(
            date,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getOrderStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Delivered';
      case 'shipped':
        return 'In Transit';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Processing';
    }
  }

  IconData _getStatusIcon() {
    switch (currentStatus.value) {
      case 'completed':
        return Iconsax.tick_circle5;
      case 'shipped':
        return Icons.local_shipping;
      case 'cancelled':
        return Iconsax.close_circle5;
      default:
        return Iconsax.timer;
    }
  }

  Color _getStatusColor() {
    switch (currentStatus.value) {
      case 'completed':
        return Colors.green;
      case 'shipped':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _buildProductDetails() {
    final selectedVariant = order.product?.variants.firstWhere(
          (variant) => variant.id == order.variantId,
      //orElse: () => order.product!.variants.first,
    );

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.md),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Sizes.md),
          Row(
            children: [
              selectedVariant?.image != null && selectedVariant!.image.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.sm),
                child: Image.network(
                  selectedVariant.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              )
                  : Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(Sizes.sm),
                ),
                child: const Icon(
                  Iconsax.image,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              const SizedBox(width: Sizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.product?.name ?? 'Product Name',
                      style: Get.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Sizes.xs),
                    Text(
                      'Quantity: ${order.quantity}',
                      style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: Sizes.sm),
                    if (selectedVariant != null) ...[
                      Row(
                        children: [
                          if (selectedVariant.color != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle,
                                      size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    selectedVariant.color!,
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (selectedVariant.color != null)
                            const SizedBox(width: Sizes.sm),
                          if (selectedVariant.size != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.straighten,
                                      size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    selectedVariant.size!,
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: Sizes.sm),
                    Text(
                      '\৳${order.price}',
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails() {
    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.md),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Details',
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Sizes.md),
          _buildInfoRow(Iconsax.user, 'Name', order.shippingInfo?.name ?? ''),
          _buildInfoRow(
            Iconsax.location,
            'Address',
            '${order.shippingInfo?.address1 ?? ''}, ${order.shippingInfo?.city ?? ''}, ${order.shippingInfo?.state ?? ''}, ${order.shippingInfo?.country ?? ''}',
          ),
          _buildInfoRow(Iconsax.call, 'Phone', order.shippingInfo?.phone ?? ''),
          _buildInfoRow(Iconsax.car, 'Delivery Method', order.shippingInfo?.method ?? ''),
          _buildInfoRow(Iconsax.money, 'Delivery Fee', order.shippingInfo?.deliveryFee ?? ''),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: Sizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Text(
                  value,
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final shippingCharge = double.tryParse(order.shippingCharge ?? '0') ?? 0.0;
    final commission = double.tryParse(order.commission ?? '0') ?? 0.0;
    final vat = double.tryParse(order.vat ?? '0') ?? 0.0;
    final transactionCost = double.tryParse(order.transactionCost ?? '0') ?? 0.0;
    final total = (order.price ?? 0) + shippingCharge + commission + vat + transactionCost;

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.md),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Sizes.md),
          _buildPriceRow('Subtotal', order.price ?? 0),
          _buildPriceRow('Shipping Fee', shippingCharge),
          _buildPriceRow('Commission', commission),
          _buildPriceRow('VAT', vat),
          _buildPriceRow('Transaction Cost', transactionCost),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.sm),
            child: Divider(),
          ),
          _buildPriceRow(
            'Total',
            total,
            textStyle: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, dynamic amount, {TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle ?? Get.textTheme.bodyMedium),
          Text(
            '\৳$amount',
            style: textStyle ?? Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }


}
