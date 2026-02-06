import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


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
                    // const SizedBox(height: 24),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Income vs Expenses",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    //bar chart
                    _buildBarChart(),
                    //pie chart
                    const SizedBox(height: 24),
                    _buildSpendingDistribution(),
                    //spending pattern
                    const SizedBox(height: 24),
                    _buildWeeklySpendingTrend(),
                    //last pattern
                    const SizedBox(height: 24),
                    _buildSpendingPatterns(),
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

  //bar chart
  Widget _buildBarChart() {
    final List<ChartData> chartData = [
      ChartData('Jun', 12000, 9000),
      ChartData('Jul', 13500, 9800),
      ChartData('Aug', 15000, 11500),
      ChartData('Sep', 14000, 10200),
      ChartData('Oct', 16000, 12000),
      ChartData('Nov', 15500, 8000),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Income vs Expenses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 260,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,

              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: const TextStyle(color: Colors.black54),
              ),

              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 16000,
                interval: 4000,
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(
                  width: 1,
                  dashArray: <double>[5, 5],
                  color: Color(0xFFE0E0E0),
                ),
              ),

              legend: Legend(isVisible: true, position: LegendPosition.bottom),

              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  name: 'Expenses',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  width: 0.35,
                ),
                ColumnSeries<ChartData, String>(
                  name: 'Income',
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  width: 0.35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //pie chart
  Widget _buildSpendingDistribution() {
    final List<PieData> pieData = [
      PieData('Food', 3240, Colors.orange),
      PieData('Transport', 1850, Colors.blue),
      PieData('Rent', 2000, Colors.purple),
      PieData('Shopping', 980, Colors.pink),
      PieData('Others', 250, Colors.green),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Spending Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 240,
            child: SfCircularChart(
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: <CircularSeries>[
                PieSeries<PieData, String>(
                  dataSource: pieData,
                  xValueMapper: (PieData data, _) => data.category,
                  yValueMapper: (PieData data, _) => data.amount,
                  pointColorMapper: (PieData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  radius: '80%',
                  explode: true,
                  explodeIndex: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //spending pattern
  Widget _buildWeeklySpendingTrend() {
    final List<WeeklyData> weeklyData = [
      WeeklyData('Mon', 800),
      WeeklyData('Tue', 1150),
      WeeklyData('Wed', 650),
      WeeklyData('Thu', 1450),
      WeeklyData('Fri', 2200),
      WeeklyData('Sat', 1800),
      WeeklyData('Sun', 900),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Spending Trend",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 2200,
                interval: 550,
                majorGridLines: const MajorGridLines(
                  width: 1,
                  dashArray: <double>[5, 5],
                ),
              ),
              series: <CartesianSeries>[
                SplineSeries<WeeklyData, String>(
                  dataSource: weeklyData,
                  xValueMapper: (WeeklyData data, _) => data.day,
                  yValueMapper: (WeeklyData data, _) => data.amount,
                  color: Colors.deepPurple,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 8,
                    width: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Spending Patterns Insight Card
  Widget _buildSpendingPatterns() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Spending Patterns",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _patternTile(
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
            bgColor: Colors.blue.shade50,
            title: "Weekend Spending",
            description:
                "You spend 35% more on weekends, mainly on entertainment and dining out.",
          ),

          const SizedBox(height: 12),

          _patternTile(
            icon: Icons.trending_down,
            iconColor: Colors.green,
            bgColor: Colors.green.shade50,
            title: "Improving Habits",
            description:
                "Your transport expenses decreased by 18% this month. Keep it up!",
          ),

          const SizedBox(height: 12),

          _patternTile(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.orange,
            bgColor: Colors.orange.shade50,
            title: "Watch Out",
            description:
                "Food delivery expenses increased by 42% compared to last month.",
          ),
        ],
      ),
    );
  }

  Widget _patternTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x; // Month
  final double y; // Income
  final double y1; // Expenses
}

class PieData {
  PieData(this.category, this.amount, this.color);
  final String category;
  final double amount;
  final Color color;
}

class WeeklyData {
  WeeklyData(this.day, this.amount);
  final String day;
  final double amount;
}
