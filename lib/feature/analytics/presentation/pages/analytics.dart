import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_bloc.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_event.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'month';
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<AnalyticsBloc>().add(
      FetchAnalyticsData(period: _selectedPeriod),
    );
  }

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

              child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                builder: (context, state) {
                  if (state is AnalyticsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AnalyticsLoaded) {
                    return _buildContent(state);
                  } else if (state is AnalyticsError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AnalyticsLoaded state) {
    if (state.weeklyTrendData.isEmpty && state.barChartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "No data available for this period",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () => _fetch(), child: const Text("Refresh")),
          ],
        ),
      );
    }
    return SingleChildScrollView(
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
                state.period == 'week'
                    ? "Top Spending Day"
                    : (state.period == 'month'
                          ? "Top Spending Date"
                          : "Top Spending Month"),
                state.topSpendingLabel,
                Colors.orange[50]!,
                Colors.orange,
              ),
              _analyticsGridCard(
                "Avg Daily Spend",
                state.avgDailySpend,
                Colors.green[50]!,
                Colors.green,
              ),
              _analyticsGridCard(
                "Most Used Category",
                state.mostUsedCategory,
                Colors.purple[50]!,
                Colors.purple,
              ),
              _analyticsGridCard(
                "Savings Rate",
                state.savingsRate,
                Colors.blue[50]!,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildBarChart(state.barChartData),
          const SizedBox(height: 24),
          _buildSpendingDistribution(state.pieChartData),
          const SizedBox(height: 24),
          _buildWeeklySpendingTrend(state.weeklyTrendData),
          const SizedBox(height: 24),
          _buildSpendingPatterns(state),
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

  Widget _buildBarChart(List<ChartData> data) {
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
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  name: 'Expenses',
                  dataSource: data,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y1,
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                ColumnSeries<ChartData, String>(
                  name: 'Income',
                  dataSource: data,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingDistribution(List<PieData> data) {
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
              ),
              series: <CircularSeries>[
                PieSeries<PieData, String>(
                  dataSource: data,
                  xValueMapper: (PieData d, _) => d.category,
                  yValueMapper: (PieData d, _) => d.amount,
                  pointColorMapper: (PieData d, _) => d.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                  explode: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySpendingTrend(List<WeeklyData> data) {
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
            "Spending Trend",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),

              series: <CartesianSeries<WeeklyData, String>>[
                SplineSeries<WeeklyData, String>(
                  dataSource: data,

                  xValueMapper: (WeeklyData d, _) => d.day.toString(),
                  yValueMapper: (WeeklyData d, _) => d.amount,
                  color: Colors.deepPurple,
                  width: 3,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingPatterns(AnalyticsLoaded state) {
    bool isSavingWell = int.parse(state.savingsRate.replaceAll('%', '')) > 20;
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
            icon: isSavingWell ? Icons.trending_up : Icons.warning,
            iconColor: isSavingWell ? Colors.green : Colors.orange,
            bgColor: isSavingWell ? Colors.green[50]! : Colors.orange[50]!,
            title: isSavingWell ? "Healthy Savings" : "Budget Alert",
            description: isSavingWell
                ? "Your savings rate of ${state.savingsRate} is excellent for this ${state.period}!"
                : "Your spending is high relative to income. Try to reduce '${state.mostUsedCategory}' expenses.",
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
          _filterChip("This Week", 'week'),

          _filterChip("This Month", 'month'),

          _filterChip("This Year", 'year'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String apiValue) {
    final bool isSelected = _selectedPeriod == apiValue;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedPeriod = apiValue);
        _fetch();
      },
      child: Container(
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
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final num y;
  final num y1;
}

class PieData {
  PieData(this.category, this.amount, this.color);
  final String category;
  final num amount;
  final Color color;
}

class WeeklyData {
  WeeklyData(this.day, this.amount);
  final String day;
  final num amount;
}
