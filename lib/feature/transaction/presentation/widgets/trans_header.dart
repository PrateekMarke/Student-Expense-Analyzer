import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/widgets/add_trans_dialogue.dart';
import '../bloc/automation_bloc.dart';

class TransactionHeader extends StatefulWidget {
  final String activeType;
  final Function(String type, {String? query}) onFilterChanged;
  final VoidCallback onRefresh;

  const TransactionHeader({
    super.key,
    required this.activeType,
    required this.onFilterChanged,
    required this.onRefresh,
  });

  @override
  State<TransactionHeader> createState() => _TransactionHeaderState();
}

class _TransactionHeaderState extends State<TransactionHeader> {
  bool _isSearching = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onFilterChanged(widget.activeType, query: query);
    });
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isSearching
                  ? Expanded(child: _buildSearchBar())
                  : const Text(
                      "Transactions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _isSearching = !_isSearching);
                      if (!_isSearching) {
                        _searchController.clear();
                        widget.onFilterChanged(widget.activeType, query: "");
                      }
                    },
                  ),
                  if (!_isSearching)
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        final automationBloc = BlocProvider.of<AutomationBloc>(
                          context,
                        );
                        showAddTransactionDialog(
                          context,
                          automationBloc,
                          widget.onRefresh,
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (!_isSearching)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: "All",
                    type: 'all',
                    activeType: widget.activeType,
                    onTap: widget.onFilterChanged,
                  ),
                  _FilterChip(
                    label: "Expenses",
                    type: 'withdrawal',
                    activeType: widget.activeType,
                    onTap: widget.onFilterChanged,
                  ),
                  _FilterChip(
                    label: "Income",
                    type: 'deposit',
                    activeType: widget.activeType,
                    onTap: widget.onFilterChanged,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Search title, category, or amount...",
          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.white54, size: 20),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label, type, activeType;
  final Function(String) onTap;

  const _FilterChip({
    required this.label,
    required this.type,
    required this.activeType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = activeType == type;
    return GestureDetector(
      onTap: () => onTap(type),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.purple : Colors.white),
        ),
      ),
    );
  }
}
