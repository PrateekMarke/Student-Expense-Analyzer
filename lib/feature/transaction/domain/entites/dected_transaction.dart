import 'package:equatable/equatable.dart';

class DetectedTransaction extends Equatable {
  final String title;
  final double amount;
  final String rawBody;
  final String source;
  final String type;

  const DetectedTransaction({required this.amount, required this.rawBody, required this.source, required this.title, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'rawBody': rawBody,
      'source': source,
      'title': title,
      'type': type,
    };
  }

  factory DetectedTransaction.fromMap(Map<String, dynamic> map) {
    return DetectedTransaction(
      amount: map['amount'],
      rawBody: map['rawBody'],
      source: map['source'], 
      title: map['title'], type: map['type'],
    );
  }

  @override
  List<Object?> get props => [amount, rawBody, source, title , type];
}