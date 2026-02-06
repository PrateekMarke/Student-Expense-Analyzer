abstract class DashboardEvent {}

class FetchDashboardData extends DashboardEvent {
  final int limit;
  FetchDashboardData({this.limit = 5});
}