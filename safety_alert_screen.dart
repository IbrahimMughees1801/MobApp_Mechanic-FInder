import 'package:flutter/material.dart';

class SafetyAlertScreen extends StatelessWidget {
  const SafetyAlertScreen({Key? key}) : super(key: key);

  void _alertNow(BuildContext context) async {
    // Placeholder: integrate real alert (SMS/call/API) later
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirm Alert'),
        content: const Text('Send emergency alert to safety services now?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(c).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Safety services alerted')),
              );
              Navigator.of(context).pop(); // return to menu
            },
            child: const Text('Send', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'If you are in danger, use the button below to alert local safety services. This will notify emergency contacts (placeholder).',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _alertNow(context),
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text('Alert Safety Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const _SafetyTipsScreen()),
                );
              },
              child: const Text('Safety Tips'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyTipsScreen extends StatelessWidget {
  const _SafetyTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Tips'), backgroundColor: Colors.deepPurple),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '1. Share your live location with a trusted contact.\n'
          '2. Avoid isolated areas.\n'
          '3. If threatened, call local emergency number.\n'
          '4. Record details (plate, name) and report.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}