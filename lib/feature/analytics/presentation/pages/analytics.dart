import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6200EE),
      appBar: AppBar(
        title: const Text("Analytics", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTimeFilters(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _analyticsGridCard(
                          "Top Spending Day",
                          "Friday",
                          Colors.orange[50]!,
                          Colors.orange,
                        ),
                        _analyticsGridCard(
                          "Avg Daily Spend",
                          "₹277",
                          Colors.green[50]!,
                          Colors.green,
                        ),
                        _analyticsGridCard(
                          "Most Used Category",
                          "Food",
                          Colors.purple[50]!,
                          Colors.purple,
                        ),
                        _analyticsGridCard(
                          "Savings Rate",
                          "45%",
                          Colors.blue[50]!,
                          Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Income vs Expenses",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // _buildBarChart(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsGridCard(String title, String value, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBarChart() {
  //   return SizedBox(
  //     height: 250,
  //     child: BarChart(
  //       BarChartData(
  //         alignment: BarChartAlignment.spaceAround,
  //         maxY: 16000,
  //         barGroups: [
  //           _makeGroupData(0, 12000, 9000),
  //           _makeGroupData(1, 13500, 10000),
  //           _makeGroupData(2, 15000, 11500),
  //           _makeGroupData(3, 14000, 10500),
  //         ],
  //         // Add axis titles and styling here...
  //       ),
  //     ),
  //   );
  // }

  // BarChartGroupData _makeGroupData(int x, double y1, double y2) {
  //   return BarChartGroupData(x: x, barRods: [
  //     BarChartRodData(toY: y1, color: Colors.green, width: 12),
  //     BarChartRodData(toY: y2, color: Colors.orange, width: 12),
  //   ]);
  // }

  Widget _buildTimeFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterChip("This Week", false),
          _filterChip("This Month", true),
          _filterChip("This Year", false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.purple : Colors.white),
      ),
    );
  }
}
