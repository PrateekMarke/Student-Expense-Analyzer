import 'package:equatable/equatable.dart';

class DetectedTransaction extends Equatable {
  final double amount;
  final String rawBody;
  final String source;

  const DetectedTransaction({required this.amount, required this.rawBody, required this.source});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'rawBody': rawBody,
      'source': source,
    };
  }

  factory DetectedTransaction.fromMap(Map<String, dynamic> map) {
    return DetectedTransaction(
      amount: map['amount'],
      rawBody: map['rawBody'],
      source: map['source'],
    );
  }

  @override
  List<Object?> get props => [amount, rawBody, source];
}