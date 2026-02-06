import 'package:equatable/equatable.dart';

class RecentTranscation extends Equatable {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String type; 
  final DateTime date;

  const RecentTranscation({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  List<Object?> get props => [id, title, category, amount, type, date];
}