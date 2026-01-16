import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = 'HomeScreen';
  static const routePath = '/HomeScreen';

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
                _categoryProgress("Food", 3240, 0.39, Colors.orange),
                _categoryProgress("Transport", 1850, 0.22, Colors.blue),
                _categoryProgress("Rent", 2000, 0.24, Colors.purple),
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
              Container(
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
                    const Text(
                      "₹12,450",
                      style: TextStyle(
                        color: Colors.white,
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
                          "₹15,000",
                          Icons.arrow_downward,
                          Colors.green,
                        ),
                        _balanceStat(
                          "Expenses",
                          "₹8,320",
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
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
