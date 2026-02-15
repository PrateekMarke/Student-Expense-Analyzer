import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_event.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_state.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/widgets/catergory_colour.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(FetchAllBudgets());
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

  void _showCategoryGoalDialog(
    BuildContext context, {
    CategorySavingGoal? goal,
  }) {
    final budgetBloc = context.read<BudgetBloc>();
    final List<String> existingCategories = [];
    if (budgetBloc.state is BudgetLoaded) {
      existingCategories.addAll(
        (budgetBloc.state as BudgetLoaded).categoryGoals.map((e) => e.category),
      );
    }
    final List<String> categories = [
      'Food',
      'Transport',
      'Rent',
      'Shopping',
      'Other',
      'Income',
    ];

    String selectedCategory = goal?.category ?? categories.first;

    final amountController = TextEditingController(
      text: goal != null ? goal.targetAmount.toStringAsFixed(0) : "",
    );

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final bool isDuplicate =
              goal == null && existingCategories.contains(selectedCategory);
          return AlertDialog(
            title: Text(
              goal == null ? "Add Category Budget" : "Update ${goal.category}",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (goal == null) ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Select Category",
                      border: const OutlineInputBorder(),
                      errorText: isDuplicate
                          ? "Budget already exists for this category"
                          : null,
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => selectedCategory = newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                ],
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Monthly Target Amount",
                    prefixText: "₹",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: isDuplicate
                    ? null
                    : () {
                        final amt = double.tryParse(amountController.text);
                        if (amt != null && selectedCategory.isNotEmpty) {
                          if (goal == null) {
                            budgetBloc.add(
                              SetCategoryGoal(selectedCategory, amt),
                            );
                          } else {
                            budgetBloc.add(
                              UpdateCategoryGoal(goal.id, goal.category, amt),
                            );
                          }
                          Navigator.pop(dialogContext);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDuplicate
                      ? Colors.grey
                      : const Color(0xFF6200EE),
                ),
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Category Budgets",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showCategoryGoalDialog(context),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF6200EE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                      if (state is BudgetLoaded &&
                              state.categoryGoals.isEmpty ||
                          state is BudgetError) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No category budgets set. Tap + to add one!",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      if (state is BudgetLoaded) {
                        return Column(
                          children: state.categoryGoals.map((goal) {
                            double percent = goal.targetAmount > 0
                                ? (goal.expensesAmount / goal.targetAmount)
                                      .clamp(0.0, 1.0)
                                : 0.0;

                            return _budgetTile(
                              goal.category,
                              "₹${goal.expensesAmount.toInt()} of ₹${goal.targetAmount.toInt()}",
                              percent,
                              getCategoryColor(goal.category),
                              isOver: goal.remainingAmount < 0,
                              onEdit: () =>
                                  _showCategoryGoalDialog(context, goal: goal),
                            );
                          }).toList(),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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

        if (state is BudgetError) {
          target = 0.0;
          remaining = 0.0;
          spent = 0.0;
          percent = 0.0;
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
    VoidCallback? onEdit,
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
              Icon(_getCategoryIcon(title), color: color),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
              ),
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

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.fastfood;
    case 'transport':
      return Icons.directions_bus;
    case 'rent':
      return Icons.home;
    case 'shopping':
      return Icons.shopping_bag;
    case 'income':
      return Icons.currency_rupee;
    default:
      return Icons.category;
  }
}
