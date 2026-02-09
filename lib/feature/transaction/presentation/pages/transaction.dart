import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/widgets/trans_header.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/widgets/trans_list.dart';
import '../bloc/automation_bloc.dart';
import '../bloc/automation_state.dart';
import '../bloc/transcation_bloc.dart';
import '../bloc/transcation_event.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _activeType = 'all';

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
      FetchTransactions(type: _activeType, isRefresh: isRefresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AutomationBloc, AutomationState>(
      listener: (context, state) {
        if (state is TransactionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF6200EE),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
           TransactionHeader(
  activeType: _activeType,
  onFilterChanged: (type, {query}) {
    setState(() => _activeType = type);
    context.read<TransactionBloc>().add(
      FetchTransactions(
        type: type, 
        query: query, 
        isRefresh: true
      ),
    );
  },
  onRefresh: () => _fetch(isRefresh: true),
),
              Expanded(
                child: TransactionList(scrollController: _scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
