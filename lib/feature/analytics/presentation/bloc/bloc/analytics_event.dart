import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAnalyticsData extends AnalyticsEvent {
  final String period; 
  FetchAnalyticsData({required this.period});

  @override
  List<Object?> get props => [period];
}