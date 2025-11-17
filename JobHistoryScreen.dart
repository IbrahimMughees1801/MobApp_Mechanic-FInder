import 'package:flutter/material.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _history = const [
    {'id': 'h1', 'title': 'Flat tire', 'date': '2025-10-02', 'status': 'completed', 'amount': '₨ 800'},
    {'id': 'h2', 'title': 'Battery jump', 'date': '2025-09-28', 'status': 'completed', 'amount': '₨ 600'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job History'), backgroundColor: Colors.deepOrange),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final j = _history[i];
          return Card(
            child: ListTile(
              title: Text(j['title'] ?? ''),
              subtitle: Text('${j['date']} • ${j['status']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(j['amount'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      // open details / rating screen later
                    },
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}