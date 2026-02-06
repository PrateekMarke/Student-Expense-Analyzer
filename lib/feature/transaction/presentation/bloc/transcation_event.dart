import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTransactions extends TransactionEvent {
  final String? type; 
  final String? period; 
  final String? date; 
  final bool isRefresh; 

  FetchTransactions({
    this.type,
    this.period,
    this.date,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [type, period,date, isRefresh];
}