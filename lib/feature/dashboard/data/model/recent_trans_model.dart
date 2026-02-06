import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';

class RecentTransModel extends RecentTranscation {
  const RecentTransModel({
    required super.id,
    required super.title,
    required super.category,
    required super.amount,
    required super.type,
    required super.date,
  });

  factory RecentTransModel.fromJson(Map<String, dynamic> json) {
    return RecentTransModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      category: json['category'] ?? 'Others',
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] ?? 'deposit',
      date: DateTime.parse(json['createdAt']),
    );
  }
}
