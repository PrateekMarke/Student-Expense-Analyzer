import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_event.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/pages/analytics.dart';

import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_category_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/widgets/catergory_colour.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/get_filtered_trans.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetFilteredTransactions getTransactions;
  final GetCategorySpending getCategorySpending;

  AnalyticsBloc(this.getTransactions, {required this.getCategorySpending}) : super(AnalyticsInitial()) {
    on<FetchAnalyticsData>((event, emit) async {
      emit(AnalyticsLoading());
      try {
       
        final results = await Future.wait([
          getTransactions(type: 'all', period: event.period, limit: 100),
          getCategorySpending(),
        ]);

        final list = results[0] as List;
        final categoryTotals = results[1] as List;
        Map<String, int> counts = {};
  double totalIncome = 0;
  double totalExpense = 0;
        if (list.isEmpty && categoryTotals.isEmpty) {
          emit(AnalyticsLoaded(
            barChartData: [],
            weeklyTrendData: [],
            pieChartData: [],
            period: event.period,
            topSpendingLabel: "No Data",
            avgDailySpend: "₹0", mostUsedCategory: 'No Data', savingsRate: '0%',
          ));
          return;
        }
for (var tx in list) {
    if (tx.type == 'withdrawal') {
      counts[tx.category] = (counts[tx.category] ?? 0) + 1;
      totalExpense += tx.amount;
    } else {
      totalIncome += tx.amount;
    }
  }

  String mostUsed = "N/A";
  if (counts.isNotEmpty) {
    mostUsed = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }


  String savingsRate = "0%";
  if (totalIncome > 0) {
    double rate = ((totalIncome - totalExpense) / totalIncome) * 100;
    savingsRate = "${rate.clamp(0, 100).toStringAsFixed(0)}%";
  }
      
        final pieData = categoryTotals.map((item) {
          return PieData(
            item.category,
            item.withdrawalTotal,
            getCategoryColor(item.category),
          );
        }).toList();

       
        final barData = _processBarData(list, event.period);
        final trendData = _processTrendData(list, event.period);

     
        String topLabel = "N/A";
        num maxAmt = -1;
        num totalSpent = 0;

        for (var data in trendData) {
          totalSpent += data.amount;
          if (data.amount > maxAmt) {
            maxAmt = data.amount;
            topLabel = data.day;
          }
        }

        if (event.period == 'month' && topLabel != "N/A") topLabel = "${topLabel}th";

        int divider = event.period == 'week' ? 7 : (event.period == 'month' ? 30 : 365);
        String avgSpend = "₹${(totalSpent / divider).toStringAsFixed(0)}";

        emit(AnalyticsLoaded(
          barChartData: barData,
          weeklyTrendData: trendData,
          pieChartData: pieData,
          period: event.period,
          topSpendingLabel: topLabel,
          avgDailySpend: avgSpend, mostUsedCategory: mostUsed,
    savingsRate: savingsRate,
        ));
      } catch (e) {
        emit(AnalyticsError("Failed to fetch analytics: ${e.toString()}"));
      }
    });
  }



 
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

