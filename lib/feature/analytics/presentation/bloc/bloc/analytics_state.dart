import 'package:equatable/equatable.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/pages/analytics.dart';

abstract class AnalyticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<ChartData> barChartData;
  final List<WeeklyData> weeklyTrendData;
  final List<PieData> pieChartData;
  final String period;
  final String topSpendingLabel;
  final String avgDailySpend;

  AnalyticsLoaded({
    required this.barChartData,
    required this.weeklyTrendData,
    required this.pieChartData,
    required this.period,
    required this.topSpendingLabel,
    required this.avgDailySpend,
  });

  @override
  List<Object?> get props => [
    barChartData,
    weeklyTrendData,
    period,
    topSpendingLabel,
    pieChartData,
    avgDailySpend,
  ];
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
