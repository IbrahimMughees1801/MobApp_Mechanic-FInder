import 'package:flutter/material.dart';
import 'mechanic_job_details_screen.dart';

class MechanicRequestsScreen extends StatefulWidget {
  const MechanicRequestsScreen({Key? key}) : super(key: key);

  @override
  State<MechanicRequestsScreen> createState() => _MechanicRequestsScreenState();
}

class _MechanicRequestsScreenState extends State<MechanicRequestsScreen> {
  // sample in-memory requests (now include description and phone)
  final List<Map<String, String>> _requests = [
    {
      'id': 'r1',
      'title': 'Car breakdown',
      'location': 'Model Town, Lahore',
      'customer': 'Ali',
      'phone': '+923001234567',
      'eta': '5 min',
      'description': 'Engine stalled, car won\'t start. Needs towing or on-site fix.'
    },
    {
      'id': 'r2',
      'title': 'Flat tire',
      'location': 'Gulberg, Lahore',
      'customer': 'Sara',
      'phone': '+923009876543',
      'eta': '12 min',
      'description': 'Rear-right tyre punctured, spare available.'
    },
  ];

  void _accept(String id) {
    final job = _requests.firstWhere((r) => r['id'] == id);
    setState(() => _requests.removeWhere((r) => r['id'] == id));

    // Return the accepted job to the caller (MechanicHomeScreen) so it can append to current jobs.
    Navigator.pop(context, job);

    // Note: MechanicHomeScreen will open job details after receiving this result.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted')));
    // TODO: signal backend / update job state
  }

  void _decline(String id) {
    setState(() => _requests.removeWhere((r) => r['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request declined')));
    // TODO: notify backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Requests'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _requests.isEmpty
          ? const Center(child: Text('No requests at the moment'))
          : ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, i) {
                final r = _requests[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(r['title'] ?? ''),
                    subtitle: Text('${r['location']} • ${r['customer']}'),
                    onTap: () {
                      // preview full job details without accepting
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MechanicJobDetailsScreen(job: r)),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(onPressed: () => _decline(r['id']!), child: const Text('Decline')),
                        const SizedBox(width: 6),
                        ElevatedButton(onPressed: () => _accept(r['id']!), child: const Text('Accept')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}