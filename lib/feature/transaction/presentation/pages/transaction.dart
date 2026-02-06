import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/core/utils/date_formatter.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_event.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_state.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _activeType = 'all';
  String? _activePeriod;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetch(isRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _fetch(isRefresh: false);
    }
  }

  void _fetch({bool isRefresh = false}) {
    context.read<TransactionBloc>().add(
      FetchTransactions(
        type: _activeType,
        period: _activePeriod,
        isRefresh: isRefresh,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6200EE),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TransactionLoaded) {
                      if (state.transactions.isEmpty) {
                        return const Center(
                          child: Text("No transactions found"),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),

                        itemCount: state.hasReachedMax
                            ? state.transactions.length
                            : state.transactions.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.transactions.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final tx = state.transactions[index];
                          final bool isFirstItem = index == 0;
                          bool showHeader = false;
                          if (isFirstItem) {
                            showHeader = true;
                          } else {
                            final prevTx = state.transactions[index - 1];
                            if (tx.date.day != prevTx.date.day ||
                                tx.date.month != prevTx.date.month) {
                              showHeader = true;
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showHeader)
                                _sectionHeader(
                                  DateFormatter.formatToShortDate(tx.date),
                                ),
                              _buildTransactionItem(tx),
                            ],
                          );
                        },
                      );
                    }

                    if (state is TransactionError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.calendar_month, color: Colors.white),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    context.read<TransactionBloc>().add(
                      FetchTransactions(
                        type: _activeType,
                        date: picked
                            .toIso8601String(), 
                        period:
                            'week', 
                        isRefresh: true,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 15),

          const SizedBox(height: 15),
          Row(
            children: [
              _filterChip("All", 'all'),
              _filterChip("Expenses", 'withdrawal'),
              _filterChip("Income", 'deposit'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String apiType) {
    final bool isSelected = _activeType == apiType;
    return GestureDetector(
      onTap: () {
        if (_activeType == apiType) return;
        setState(() => _activeType = apiType);
        _fetch(isRefresh: true);
      },
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

  Widget _buildTransactionItem(RecentTranscation tx) {
    final bool isDeposit = tx.type == 'deposit';
    final String amountSign = isDeposit ? "+" : "-";
    final Color color = isDeposit ? Colors.green : Colors.red;

    IconData iconData = isDeposit ? Icons.school : Icons.shopping_bag;
    if (tx.category.toLowerCase().contains('food')) iconData = Icons.coffee;
    if (tx.category.toLowerCase().contains('transport'))
      iconData = Icons.directions_car;

    return _transactionTile(
      tx.title,
      "${tx.category} • ${DateFormatter.formatReadable(tx.date)}",
      "$amountSign₹${tx.amount.toInt()}",
      iconData,
      color,
    );
  }

  Widget _transactionTile(
    String title,
    String subtitle,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amount.startsWith('+') ? Colors.green : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
