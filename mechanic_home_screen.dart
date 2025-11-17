import 'package:flutter/material.dart';
import 'mechanic_requests_screen.dart';
import 'mechanic_job_details_screen.dart'; // added import
import 'mechanic_earnings_screen.dart';
import 'mechanic_profile_screen.dart';
import 'menu_screen.dart'; // <-- allow mechanic to open same menu

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({Key? key}) : super(key: key);

  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  bool _available = true;

  // sample stats / jobs - replace with backend data later
  final double _hoursWorkedToday = 6.5;
  final int _completedJobsToday = 3;
  final List<Map<String, String>> _currentJobs = [
    {'id': 'j1', 'title': 'Car breakdown', 'customer': 'Ali', 'eta': '5 min'},
    {'id': 'j2', 'title': 'Flat tire', 'customer': 'Sara', 'eta': '12 min'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Dashboard'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicProfileScreen()));
            },
          ),
          // Menu button for mechanic -> opens same shared MenuScreen
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // welcome + stats
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back,', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      const Text('Mechanic', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Hours today: ${_hoursWorkedToday.toStringAsFixed(1)}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Jobs: $_completedJobsToday', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicEarningsScreen()));
                      },
                      icon: const Icon(Icons.account_balance_wallet, size: 18),
                      label: const Text('Earnings'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: const Icon(Icons.radio_button_checked, color: Colors.green),
                title: const Text('Availability'),
                subtitle: Text(_available ? 'Available for jobs' : 'Not available'),
                trailing: Switch(
                  value: _available,
                  onChanged: (v) => setState(() => _available = v),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // current jobs list
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Current jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: _currentJobs.isEmpty
                        ? const Center(child: Text('No current jobs'))
                        : ListView.separated(
                            itemCount: _currentJobs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final job = _currentJobs[i];
                              return Card(
                                child: ListTile(
                                  title: Text(job['title'] ?? ''),
                                  subtitle: Text('Customer: ${job['customer']} • ETA: ${job['eta']}'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      // open job details (pass job map)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => MechanicJobDetailsScreen(job: job)),
                                      );
                                    },
                                    child: const Text('View'),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // open requests and wait for an accepted job returned from the requests screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MechanicRequestsScreen()),
          );

          if (result != null && result is Map<String, String>) {
            // add to current jobs (show newest first)
            setState(() => _currentJobs.insert(0, result));

            // immediately open job details so mechanic can send updates / call client
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MechanicJobDetailsScreen(job: result)),
            );
          }
        },
        child: const Icon(Icons.list),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}