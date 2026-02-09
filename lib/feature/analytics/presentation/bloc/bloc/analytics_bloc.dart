import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_event.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/pages/analytics.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/get_filtered_trans.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetFilteredTransactions getTransactions;

  AnalyticsBloc(this.getTransactions) : super(AnalyticsInitial()) {
    on<FetchAnalyticsData>((event, emit) async {
      emit(AnalyticsLoading());
   
try {
  final list = await getTransactions(type: 'all', period: event.period, limit: 100);
  if (list.isEmpty) {
  emit(AnalyticsLoaded(
    barChartData: [],
    weeklyTrendData: [],
    period: event.period,
    topSpendingLabel: "No Data",
    avgDailySpend: "₹0",
  ));
  return;
}
  final barData = _processBarData(list, event.period);
  final trendData = _processTrendData(list, event.period);

  String topSpendingLabel = "N/A";
  num maxAmount = -1;
  num totalSpent = 0;

  for (var data in trendData) {
    totalSpent += data.amount;
    if (data.amount > maxAmount) {
      maxAmount = data.amount;
      topSpendingLabel = data.day; 
    }
  }


  if (event.period == 'month' && topSpendingLabel != "N/A") {
    topSpendingLabel = "${topSpendingLabel}th"; 
  }


  int divider = event.period == 'week' ? 7 : (event.period == 'month' ? 30 : 365);
  String avgSpend = "₹${(totalSpent / divider).toStringAsFixed(0)}";
  

  emit(AnalyticsLoaded(
    barChartData: barData,
    weeklyTrendData: trendData,
    period: event.period,
    topSpendingLabel: topSpendingLabel,
    avgDailySpend: avgSpend,
  ));
} catch (e) {
  emit(AnalyticsError("Failed to fetch analytics: ${e.toString()}"));
}
    });
  }

  List<ChartData> _processBarData(List list, String period) {
   
    final Map<String, Map<String, double>> dataMap = {};

    
    List<String> keys = [];
    if (period == 'week') {
      keys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else if (period == 'month') {
      keys = ['5', '10', '15', '20', '25', '30'];
    } else {
      keys = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
    }

    for (var key in keys) {
      dataMap[key] = {'income': 0.0, 'expense': 0.0};
    }

    for (var tx in list) {
      final double amt = double.tryParse(tx.amount.toString()) ?? 0.0;
      String key;

      if (period == 'week') {
        key = DateFormat('E').format(tx.date);
      } else if (period == 'month') {
        int day = tx.date.day;
        if (day <= 5) {
          key = '5';
        } else if (day <= 10){
          key = '10';
        }else if (day <= 15){
          key = '15';
        }else if (day <= 20){
          key = '20';
        }else if (day <= 25){
          key = '25';
        }else{
          key = '30';}
      } else {
        key = DateFormat('MMM').format(tx.date);
      }

      if (dataMap.containsKey(key)) {
        if (tx.type == 'deposit') {
          dataMap[key]!['income'] = dataMap[key]!['income']! + amt;
        } else {
          dataMap[key]!['expense'] = dataMap[key]!['expense']! + amt;
        }
      }
    }

    return dataMap.entries
        .map((e) => ChartData(e.key, e.value['income']!, e.value['expense']!))
        .toList();
  }

  List<WeeklyData> _processTrendData(List list, String period) {
    if (period == 'week') {
      final Map<String, double> dataMap = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      };
      for (var tx in list) {
        if (tx.type == 'withdrawal') {
          String day = DateFormat('E').format(tx.date);
          if (dataMap.containsKey(day)) {
            dataMap[day] =
                dataMap[day]! + (double.tryParse(tx.amount.toString()) ?? 0.0);
          }
        }
      }
      return dataMap.entries.map((e) => WeeklyData(e.key, e.value)).toList();
    } else if (period == 'month') {
      final Map<String, double> dataMap = {
        '5': 0,
        '10': 0,
        '15': 0,
        '20': 0,
        '25': 0,
        '30': 0,
      };
      for (var tx in list) {
        if (tx.type == 'withdrawal') {
          int day = tx.date.day;
          String key;
          if (day <= 5) {
            key = '5';
          } else if (day <= 10){
            key = '10';
          }else if (day <= 15){
            key = '15';
          }else if (day <= 20){
            key = '20';
          }else if (day <= 25){
            key = '25';
          }else
            key = '30';

          dataMap[key] =
              dataMap[key]! + (double.tryParse(tx.amount.toString()) ?? 0.0);
        }
      }
      return dataMap.entries.map((e) => WeeklyData(e.key, e.value)).toList();
    } else {
      final Map<String, double> dataMap = {
        'Jan': 0,
        'Feb': 0,
        'Mar': 0,
        'Apr': 0,
        'May': 0,
        'Jun': 0,
        'Jul': 0,
        'Aug': 0,
        'Sep': 0,
        'Oct': 0,
        'Nov': 0,
        'Dec': 0,
      };
      for (var tx in list) {
        if (tx.type == 'withdrawal') {
          String month = DateFormat('MMM').format(tx.date); 
          if (dataMap.containsKey(month)) {
            dataMap[month] =
                dataMap[month]! +
                (double.tryParse(tx.amount.toString()) ?? 0.0);
          }
        }
      }
      return dataMap.entries.map((e) => WeeklyData(e.key, e.value)).toList();
    }
  }
}
