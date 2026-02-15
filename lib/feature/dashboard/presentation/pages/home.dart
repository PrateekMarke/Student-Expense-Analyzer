import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_expense_analyzer/core/services/notification_manager.dart';
import 'package:student_expense_analyzer/core/utils/date_formatter.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_state.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/widgets/catergory_colour.dart';
import 'package:student_expense_analyzer/feature/transaction/data/repository/automation_repository_impl.dart';
import 'package:student_expense_analyzer/feature/transaction/data/services/automation_parser.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = 'HomeScreen';
  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _requestAllPermissions();
    context.read<DashboardBloc>().add(FetchDashboardData(limit: 5));
  }

  Future<void> _requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.notification,
    ].request();

    if (statuses[Permission.sms]!.isGranted &&
        statuses[Permission.notification]!.isGranted) {
      final repo = AutomationRepositoryImpl();
      repo.initSMSListener((transaction) {
        context.read<AutomationBloc>().add(TransactionDetected(transaction));
        NotificationManager.showCategorizationAlert(
          transaction.amount,
          transaction.title,
          transaction.type,
        );
      });
      repo.initNotificationListener((transaction) {
        context.read<AutomationBloc>().add(TransactionDetected(transaction));
        NotificationManager.showCategorizationAlert(
          transaction.amount,
          transaction.title,
          transaction.type,
        );
      });
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
          "To automate your expense tracking, this app needs access to read transaction SMS and show alerts for categorization.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smart Insights",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                _insightCard(
                  "You spent 23% more on food this week",
                  Colors.orange.withOpacity(0.1),
                  Colors.orange,
                ),
                _insightCard(
                  "Great! You're on track to meet your savings goal",
                  Colors.green.withOpacity(0.1),
                  Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Spending by Category",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoaded) {
                      if (state.categorySpending.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No spending categories yet. Add a transaction to see insights!",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return Column(
                        children: state.categorySpending.map((item) {
                          double percent = state.totalExpenses > 0
                              ? item.withdrawalTotal / state.totalExpenses
                              : 0.0;

                          return _categoryProgress(
                            item.category,
                            item.withdrawalTotal.toInt(),
                            percent.clamp(0.0, 1.0),
                            getCategoryColor(item.category),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),

                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    int currentCount = 0;
                    if (state is DashboardLoaded) {
                      currentCount = state.recentTransactions.length;
                    }

                    return _sectionHeader(
                      "Recent Transactions",
                      buttonLabel: currentCount > 5 ? "Show Less" : "See All",
                      onSeeAll: () {
                        if (currentCount <= 5) {
                          context.read<DashboardBloc>().add(
                            FetchDashboardData(limit: 10),
                          );
                        } else {
                          context.read<DashboardBloc>().add(
                            FetchDashboardData(limit: 5),
                          );
                        }
                      },
                    );
                  },
                ),

                _buildRecentTransactionsList(),
                const SizedBox(height: 24),
                _sectionHeader("Savings Goal"),
                const SizedBox(height: 12),
                _buildSavingsGoalCard(),

                ElevatedButton.icon(
                  icon: const Icon(Icons.bug_report),
                  label: const Text("Test Parser & Bloc"),
                  onPressed: () {
                    const testText =
                        "SBI Bank: Your A/c XXX123 is debited for INR 6776.00 at Meesho";
                    final amount = AutomationParser.extractAmount(testText);
                    final title = AutomationParser.extractTitle(testText);
                    final type = AutomationParser.extractType(testText);

                    if (amount != null) {
                      final tx = DetectedTransaction(
                        amount: amount,
                        rawBody: testText,
                        source: "Manual_Test",
                        title: title,
                        type: type,
                      );
                      context.read<AutomationBloc>().add(
                        TransactionDetected(tx),
                      );
                      NotificationManager.showCategorizationAlert(
                        amount,
                        title,
                        type,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String fullName = "User Name";
        String initials = "U";

        if (state is AuthSuccess) {
          fullName = "${state.user.firstName} ${state.user.lastName}";
          initials = (state.user.firstName[0] + state.user.lastName[0])
              .toUpperCase();
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF6200EE),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back,",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, dashState) {
                  double balance = 0.0;
                  double income = 0.0;
                  double expenses = 0.0;

                  if (dashState is DashboardLoaded) {
                    balance = dashState.totalBalance;
                    income = dashState.totalIncome;
                    expenses = dashState.totalExpenses;
                  }

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Balance",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "₹${balance.toStringAsFixed(0)}",
                          style: TextStyle(
                            color: balance < 0
                                ? Colors.redAccent
                                : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _balanceStat(
                              "Income",
                              "₹${income.toStringAsFixed(0)}",
                              Icons.arrow_downward,
                              Colors.green,
                            ),
                            _balanceStat(
                              "Expenses",
                              "₹${expenses.toStringAsFixed(0)}",
                              Icons.arrow_upward,
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _balanceStat(String label, String val, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _insightCard(String text, Color bg, Color border) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: border.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _categoryProgress(
    String title,
    int amount,
    double percent,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text("₹$amount")],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[200],
            color: color,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

Widget _sectionHeader(
  String title, {
  VoidCallback? onSeeAll,
  String buttonLabel = "See All",
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      if (onSeeAll != null)
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            buttonLabel,
            style: const TextStyle(
              color: Color(0xFF6200EE),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    ],
  );
}

Widget _buildRecentTransactionsList() {
  return BlocBuilder<DashboardBloc, DashboardState>(
    builder: (context, state) {
      if (state is DashboardLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is DashboardLoaded) {
        if (state.recentTransactions.isEmpty) {
          return const Center(child: Text("No transactions yet."));
        }
        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.recentTransactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _transactionTile(state.recentTransactions[index]);
              },
            ),
            if (state.recentTransactions.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Showing last ${state.recentTransactions.length} transactions",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
          ],
        );
      } else if (state is DashboardError) {
        if (state.message.contains("not found") ||
            state.message.contains("10001")) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("No transactions yet. Start spending to see data!"),
            ),
          );
        }

        return Center(child: Text(state.message));
      }
      return const SizedBox();
    },
  );
}

Widget _transactionTile(RecentTranscation tx) {
  final bool isIncome = tx.type == 'deposit';

  final String formattedDate = DateFormatter.formatReadable(tx.date);

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FE),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Icon(
            isIncome ? Icons.south_west : Icons.north_east,
            color: isIncome ? Colors.green : Colors.red,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${tx.category} • $formattedDate",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          "${isIncome ? '+' : '-'}₹${tx.amount.toInt()}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSavingsGoalCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF2FFF5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green.withOpacity(0.1)),
    ),
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Monthly Savings Target",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "83%",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: 0.83,
            minHeight: 10,
            backgroundColor: Colors.white,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "₹4,130 saved",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Goal: ₹5,000", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    ),
  );
}
