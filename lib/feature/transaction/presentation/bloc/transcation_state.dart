import 'package:equatable/equatable.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<RecentTranscation> transactions;
  final String selectedType;
  final bool hasReachedMax;

  TransactionLoaded({
    required this.transactions,
    this.selectedType = 'all',
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [transactions, selectedType, hasReachedMax];
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}