import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/order_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  final OrderController _orderController = Get.find<OrderController>();
  final UserController userController = Get.find<UserController>();

  HomeScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_orderController.all_orders_together.isEmpty) {
        _orderController.fetchAllUserOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Obx(() => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Hi, ${userController.user.value?.name ?? "Vendor"}',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideX(begin: -0.2, end: 0),
                    Text(
                      DateFormat.yMMMEd().format(DateTime.now()),
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideX(begin: -0.2, end: 0),
                  ],
                ),
              ),
              if(userController.user.value?.avatar != null)
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: CircleAvatar(
                    radius: 27.5,
                    backgroundImage: NetworkImage(
                      userController.user.value?.avatar ,
                    ),
                  ).animate()
                      .fadeIn(duration: const Duration(milliseconds: 800))
                      .scale(begin: const Offset(0.5, 0.5))
              ),
            ],
          )),
        ),
      ),
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: 40,
            ),
          );
        }

        final orders = _orderController.all_orders_together;

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        final totalRevenue = _calculateTotalRevenue(orders);
        final totalProfit = _calculateTotalProfit(orders);
        final totalOrders = orders.length;
        final pendingOrders = _getPendingOrders(orders);

        return Container(
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Till Now',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ).animate()
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideX(begin: -0.2, end: 0),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.toNamed('/finance'),
                        child: Text(
                          'All Reports',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.blue
                          ),
                        ),
                      ).animate()
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideX(begin: 0.2, end: 0),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                            'Gross Sales',
                            '\৳${totalRevenue.toStringAsFixed(2)}',
                            '+${((totalRevenue/10000)).toStringAsFixed(1)}%',
                            Icons.monetization_on,
                            Colors.blueAccent,
                            true,
                            context
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInfoCard(
                            'Earnings',
                            '\৳${totalProfit.toStringAsFixed(2)}',
                            '+${((totalProfit/100)/100 ).toStringAsFixed(1)}%',
                            Icons.account_balance_wallet,
                            Colors.red,
                            false,
                            context
                        ),
                      ),
                    ],
                  ).animate()
                      .fadeIn(duration: const Duration(milliseconds: 800))
                      .slideY(begin: 0.2, end: 0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCardWithCircleChart(
                            'Total Orders',
                            totalOrders.toString(),
                            Icons.shopping_cart,
                            Colors.green,
                            true,
                            context
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInfoCardWithCircleChart(
                            'Pending Orders',
                            pendingOrders.toString(),
                            Icons.receipt,
                            Colors.lightBlueAccent,
                            false,
                            context
                        ),
                      ),
                    ],
                  ).animate()
                      .fadeIn(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 200)
                  )
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: _buildOrderStatusBarChart(orders),
                  ).animate()
                      .fadeIn(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 200)
                  )
                      .scale(begin: const Offset(0.8, 0.8))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, String amount, String change, IconData icon,
      Color color, bool is1stCard, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Handle empty or invalid values
    amount = amount.isNotEmpty ? amount : "\৳0.00";
    change = change.isNotEmpty ? change : "0%";

    return Container(
      height: mediaQuery.size.height * 0.19,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 42),
              const Spacer(),
              Text(
                change,
                style: GoogleFonts.poppins(
                    color: (is1stCard ? color : Colors.blue)
                ),
              ),
              const Icon(Icons.arrow_upward, color: Colors.blue, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: is1stCard ? Colors.black : Colors.red,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Ensures the text truncates within a single line
          ),

          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardWithCircleChart(String title, String amount, IconData icon,
      Color color, bool is1stCard, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.19,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 42),
              const Spacer(),
              Transform.translate(
                offset: const Offset(-25, 10),
                child: _buildMiniPieChart(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: (is1stCard ? Colors.green : Colors.lightBlueAccent)
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPieChart() {
    return SizedBox(
      width: 10,
      height: 10,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.red,
              value: 15,
              title: '',
              radius: 7,
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: 20,
              title: '',
              radius: 7,
            ),
            PieChartSectionData(
              color: Colors.green,
              value: 25,
              title: '',
              radius: 7,
            ),
            PieChartSectionData(
              color: Colors.grey.shade300,
              value: 35,
              title: '',
              radius: 7,
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 15,
        ),
      ),
    );
  }

  Widget _buildOrderStatusBarChart(List<OrderModel> orders) {
    Map<String, int> statusCount = {};
    for (var order in orders) {
      final status = order.status?.toLowerCase() ?? 'unknown';
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }

    // Find the maximum value for y-axis scaling
    final maxValue = statusCount.values.reduce((curr, next) => curr > next ? curr : next).toDouble();

    return Column(
      children: [
        Text(
          'Order Status Distribution',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue + (maxValue * 0.2), // Add 20% padding to top
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['Pending', 'Shipped', 'Completed', 'Cancelled'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          titles[value.toInt()],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: maxValue / 5, // Create 5 intervals
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: maxValue / 5,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: statusCount['pending']?.toDouble() ?? 0,
                      color: Colors.purple,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: statusCount['shipped']?.toDouble() ?? 0,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: statusCount['completed']?.toDouble() ?? 0,
                      color: Colors.green,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      toY: statusCount['cancelled']?.toDouble() ?? 0,
                      color: Colors.red,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  double _calculateTotalRevenue(List<OrderModel> orders) {
    final totalProfit = _calculateTotalProfit(orders);
    final totalPrice = orders.fold(0.0, (sum, order) => sum + (order.price ?? 0));
    return totalPrice - totalProfit;
  }

  double _calculateTotalProfit(List<OrderModel> orders) {
    return orders.fold(0.0, (sum, order) => sum + double.parse(order.profit));
  }

  int _getPendingOrders(List<OrderModel> orders) {
    return orders.where((order) => order.status?.toLowerCase() == 'pending').length;
  }
}
