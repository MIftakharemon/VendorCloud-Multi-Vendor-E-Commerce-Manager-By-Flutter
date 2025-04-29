import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/models/order_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/order_controller.dart';
import '../../utils/constants/colors.dart';

class FinanceScreen extends StatelessWidget {
  static const routeName = "/finance";
  final OrderController _orderController = OrderController();
  final scrollController = ScrollController();

  FinanceScreen({super.key}) {
    _orderController.fetchUserOrders();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        _orderController.fetchUserOrders(isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Finance Dashboard',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
            onPressed: () => _orderController.fetchUserOrders(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Obx(() {
          if (_orderController.isLoading.value && _orderController.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = _orderController.orders;

          if (orders.isEmpty && !_orderController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No Orders Available',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrdersTable(orders, context),
                if (_orderController.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrdersTable(List<OrderModel> orders, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          horizontalMargin: 24,
          columnSpacing: 40, // Increased spacing between columns
          headingRowHeight: 65, // Increased header height
          dataRowHeight: 70, // Increased row height
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
          columns: [
            _buildDataColumn('No', width: 60),
            _buildDataColumn('Order Date', width: 120),
            _buildDataColumn('Order Cost', width: 120),
            _buildDataColumn('VAT', width: 100),
            _buildDataColumn('Commission', width: 120),
            _buildDataColumn('Transaction Fee', width: 140),
            _buildDataColumn('Shipping Cost', width: 130),
            _buildDataColumn('Profit', width: 120),
            _buildDataColumn('Status', width: 120),
            _buildDataColumn('Action', width: 130),
          ],
          rows: List<DataRow>.generate(
            orders.length,
                (index) => _buildDataRow(orders[index], index),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, {required double width}) {
    return DataColumn(
      label: Container(
        width: width,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(OrderModel order, int index) {
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (index.isEven) return Colors.grey.shade50;
          return null;
        },
      ),
      cells: [
        _buildDataCell((index + 1).toString(), width: 60),
        _buildDataCell(order.formattedOrderDate, width: 120),
        _buildDataCell('\$${order.price!.toStringAsFixed(2)}', width: 120),
        _buildDataCell('\$${order.vat}', width: 100),
        _buildDataCell('\$${order.commission}', width: 120),
        _buildDataCell('\$${order.transactionCost}', width: 140),
        _buildDataCell('\$${order.shippingCharge}', width: 130),
        DataCell(_buildProfitCell(formatProfit(order.profit))),
        DataCell(_buildStatusCell(order.status ?? '')),
        DataCell(_buildActionButton(
          status: order.vendorPaid ?? '',
          onPressed: () {
            // Handle action
          },
        )),
      ],
    );
  }

  DataCell _buildDataCell(String text, {required double width}) {
    return DataCell(
      Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  String formatProfit(String profit) {
    double profitValue = double.tryParse(profit) ?? 0.0;
    return profitValue.toStringAsFixed(2);
  }

  Widget _buildProfitCell(String profit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '\$$profit',
        style: GoogleFonts.poppins(
          color: double.parse(profit) >= 0 ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    final statusConfig = {
      'pending': Colors.orange,
      'shipped': Colors.deepPurpleAccent,
      'completed': Colors.green,
      'cancelled': Colors.red,
    };
    final textColor = statusConfig[status.toLowerCase()] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String status,
    required VoidCallback onPressed,
  }) {
    final isPaid = status.toLowerCase() == 'paid';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPaid ? Colors.green : Colors.blue.withOpacity(0.1),
          foregroundColor: isPaid ? Colors.white : Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isPaid ? 'Paid' : 'Not Paid',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
