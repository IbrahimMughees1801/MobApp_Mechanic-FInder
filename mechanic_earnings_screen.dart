import 'package:flutter/material.dart';

class MechanicEarningsScreen extends StatelessWidget {
  const MechanicEarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // sample data
    final total = '₨ 12,450';
    final completed = 24;
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Total earned'),
                subtitle: Text(total, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Completed jobs'),
                subtitle: Text('$completed'),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Payouts and transaction history will be implemented in backend integration.'),
          ],
        ),
      ),
    );
  }
}