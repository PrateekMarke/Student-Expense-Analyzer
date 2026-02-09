import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../dashboard/domain/entites/recent_transcation.dart';
import '../bloc/transcation_bloc.dart';
import '../bloc/transcation_state.dart';

class TransactionList extends StatelessWidget {
  final ScrollController scrollController;
  const TransactionList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) return const Center(child: CircularProgressIndicator());
          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) return const Center(child: Text("No transactions found"));

            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: state.hasReachedMax ? state.transactions.length : state.transactions.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.transactions.length) return const Center(child: CircularProgressIndicator());

                final tx = state.transactions[index];
                bool showHeader = index == 0 || _isNewDay(tx, state.transactions[index - 1]);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) _SectionHeader(date: DateFormatter.formatToShortDate(tx.date)),
                    _TransactionTile(tx: tx),
                  ],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  bool _isNewDay(RecentTranscation current, RecentTranscation previous) {
    return current.date.day != previous.date.day || current.date.month != previous.date.month;
  }
}

class _SectionHeader extends StatelessWidget {
  final String date;
  const _SectionHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(date, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final RecentTranscation tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isDeposit = tx.type == 'deposit';
    final Color color = isDeposit ? Colors.green : Colors.red;

    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(_getIcon(tx.category, isDeposit), color: color, size: 20),
        ),
        title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${tx.category} • ${DateFormatter.formatReadable(tx.date)}"),
        trailing: Text(
          "${isDeposit ? '+' : '-'}₹${tx.amount.toInt()}",
          style: TextStyle(color: isDeposit ? Colors.green : Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  IconData _getIcon(String category, bool isDeposit) {
    String cat = category.toLowerCase();
    if (cat.contains('food')) return Icons.coffee;
    if (cat.contains('transport')) return Icons.directions_car;
    return isDeposit ? Icons.school : Icons.shopping_bag;
  }
}