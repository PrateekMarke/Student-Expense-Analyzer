import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6200EE),
      appBar: AppBar(
        title: const Text("Budget Manager", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Add Budget", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
              child: ListView(
                children: [
                  const Text("Category Budgets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _budgetTile("Food", "₹3,240 of ₹4,000", 0.81, Colors.orange),
                  _budgetTile("Transport", "₹1,850 of ₹2,000", 0.92, Colors.blue),
                  _budgetTile("Rent", "₹2,000 of ₹2,000", 1.0, Colors.red, isOver: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Total Monthly Budget", style: TextStyle(color: Colors.white70)),
                Text("₹10,500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("Remaining", style: TextStyle(color: Colors.white70)),
                Text("₹1,781", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: 0.83, color: Colors.orangeAccent, backgroundColor: Colors.white24, minHeight: 10),
          const SizedBox(height: 10),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Spent: ₹8,719", style: TextStyle(color: Colors.white70)),
            Text("83%", style: TextStyle(color: Colors.white70)),
          ]),
        ],
      ),
    );
  }

  Widget _budgetTile(String title, String subtitle, double val, Color color, {bool isOver = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.fastfood, color: color), const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.edit, size: 16, color: Colors.grey),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(subtitle), Text("${(val * 100).toInt()}% used")]),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: val, color: isOver ? Colors.red : color, backgroundColor: Colors.grey[100]),
        ],
      ),
    );
  }
}