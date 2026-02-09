import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTransactions extends TransactionEvent {
  final String? type;
  final String? period;
  final String? query;
  final double? amount;
  final String? date;
  final bool isRefresh;

  FetchTransactions({
    this.type,
    this.period,
    this.date,
    this.isRefresh = false,
    this.query,
    this.amount,
  });

  @override
  List<Object?> get props => [type, period, date, isRefresh, query, amount];
}
