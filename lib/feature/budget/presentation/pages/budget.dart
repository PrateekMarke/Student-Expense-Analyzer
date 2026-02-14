import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_event.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_state.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(FetchSavingGoal());
  }

  void _showSetGoalDialog(BuildContext context, {double? currentAmount}) {
    final budgetBloc = BlocProvider.of<BudgetBloc>(context);
    final controller = TextEditingController(
      text: currentAmount != null ? currentAmount.toStringAsFixed(0) : "",
    );

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: budgetBloc,
        child: AlertDialog(
          title: Text(
            currentAmount == null
                ? "Set Monthly Budget"
                : "Update Monthly Budget",
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter amount",
              prefixText: "₹",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(controller.text);
                if (amt != null) {
                  if (currentAmount == null) {
                    budgetBloc.add(SetSavingGoal(amt));
                  } else {
                    budgetBloc.add(UpdateSavingGoal(amt));
                  }

                  Navigator.pop(dialogContext);
                }
              },
              child: Text(currentAmount == null ? "Set Goal" : "Update Goal"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Budget updated successfully!")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF6200EE),
        appBar: AppBar(
          title: const Text(
            "Budget Manager",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton.icon(
              onPressed: () {
                _showSetGoalDialog(context);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Budget",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSummaryCard(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView(
                  children: [
                    const Text(
                      "Category Budgets",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _budgetTile(
                      "Food",
                      "₹3,240 of ₹4,000",
                      0.81,
                      Colors.orange,
                    ),
                    _budgetTile(
                      "Transport",
                      "₹1,850 of ₹2,000",
                      0.92,
                      Colors.blue,
                    ),
                    _budgetTile(
                      "Rent",
                      "₹2,000 of ₹2,000",
                      1.0,
                      Colors.red,
                      isOver: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return BlocBuilder<BudgetBloc, BudgetState>(
      buildWhen: (previous, current) => current is! BudgetError,
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        double target = 0.0;
        double remaining = 0.0;
        double spent = 0.0;
        double percent = 0.0;

        if (state is BudgetLoaded) {
          final goal = state.savingGoal;
          target = goal.targetAmount;
          remaining = goal.remainingAmount;
          spent = goal.expensesAmount;

          percent = target > 0 ? (spent / target).clamp(0.0, 1.0) : 0.0;
        }
        if (target == 0 && remaining == 0 && state is BudgetLoaded) {
          print("target: $target, remaining: $remaining, state: $state");
        }
        int displayPercent = (percent * 100).toInt();

        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            target == 0
                                ? "Set Monthly Budget"
                                : "Monthly Budget",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _showSetGoalDialog(
                              context,
                              currentAmount: target > 0 ? target : null,
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "₹${target.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Remaining",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "₹${remaining.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: remaining < 0
                              ? Colors.redAccent
                              : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: percent,
                color: percent > 0.9 ? Colors.redAccent : Colors.orangeAccent,
                backgroundColor: Colors.white24,
                minHeight: 10,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Spent: ₹${spent.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "$displayPercent%",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _budgetTile(
    String title,
    String subtitle,
    double val,
    Color color, {
    bool isOver = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.fastfood, color: color),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.edit, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(subtitle), Text("${(val * 100).toInt()}% used")],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: val,
            color: isOver ? Colors.red : color,
            backgroundColor: Colors.grey[100],
          ),
        ],
      ),
    );
  }
}
