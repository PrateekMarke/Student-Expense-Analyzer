import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/automation_bloc.dart';
import '../bloc/automation_event.dart';

void showAddTransactionDialog(
  BuildContext context,
  AutomationBloc bloc,
  VoidCallback onRefresh,
) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String type = 'withdrawal';
  String category = 'Food';

  showDialog(
    context: context,
    builder: (ctx) => BlocProvider.value(
      value: bloc,
      child: StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: const Color(0xFF6200EE).withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              "Add Transaction",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _GlassInput(
                  controller: titleController,
                  hint: "Title",
                  icon: Icons.title,
                ),
                const SizedBox(height: 12),
                _GlassInput(
                  controller: amountController,
                  hint: "Amount",
                  icon: Icons.currency_rupee,
                  isNumber: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _TypeChip(
                      label: "Expense",
                      val: 'withdrawal',
                      current: type,
                      onTap: (v) => setDialogState(() => type = v),
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: "Income",
                      val: 'deposit',
                      current: type,
                      onTap: (v) => setDialogState(() => type = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _CategoryDropdown(
                  value: category,
                  onChanged: (v) => setDialogState(() => category = v!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final double? amt = double.tryParse(amountController.text);
                  if (amt != null && titleController.text.isNotEmpty) {
                    context.read<AutomationBloc>().add(
                      CreateManualTransaction(
                        amount: amt,
                        type: type,
                        category: category,
                        title: titleController.text,
                      ),
                    );
                    Navigator.pop(context);
                    onRefresh();
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isNumber;

  const _GlassInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label, val, current;
  final Function(String) onTap;

  const _TypeChip({
    required this.label,
    required this.val,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = current == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(val),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF6200EE) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;
  const _CategoryDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: const Color(0xFF6200EE),
        underline: const SizedBox(),
        isExpanded: true,
        items: ['Food', 'Transport', 'Rent', 'Shopping', 'Others']
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(v, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
