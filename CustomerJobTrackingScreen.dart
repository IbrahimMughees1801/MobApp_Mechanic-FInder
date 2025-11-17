import 'package:flutter/material.dart';
import 'ChatThreadScreen.dart';

class CustomerJobTrackingScreen extends StatefulWidget {
  final Map<String, String>? job;
  const CustomerJobTrackingScreen({Key? key, this.job}) : super(key: key);

  @override
  State<CustomerJobTrackingScreen> createState() => _CustomerJobTrackingScreenState();
}

class _CustomerJobTrackingScreenState extends State<CustomerJobTrackingScreen> {
  String _status = 'requested';
  String _mechanic = 'Unassigned';
  String _eta = 'TBD';

  @override
  void initState() {
    super.initState();
    final j = widget.job;
    if (j != null) {
      _status = j['status'] ?? _status;
      _eta = j['eta'] ?? _eta;
    }
  }

  Widget _buildStep(String label, bool done) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: done ? Colors.deepOrange : Colors.grey),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: done ? Colors.black : Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.job?['title'] ?? 'Your job';
    return Scaffold(
      appBar: AppBar(title: const Text('Track Job'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.job?['description'] ?? ''),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStep('Requested', _status == 'requested' || _status == 'accepted' || _status == 'on_the_way' || _status == 'working' || _status == 'done')),
                Expanded(child: _buildStep('Mechanic on the way', _status == 'on_the_way' || _status == 'working' || _status == 'done')),
                Expanded(child: _buildStep('Working', _status == 'working' || _status == 'done')),
                Expanded(child: _buildStep('Completed', _status == 'done')),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_pin_circle),
                title: Text('Mechanic: $_mechanic'),
                subtitle: Text('ETA: $_eta'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatThreadScreen()));
                  },
                  child: const Text('Chat'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Text('Live map / tracking placeholder', style: TextStyle(color: Colors.grey[600])),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _status = 'done';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked completed (local)')));
                    },
                    child: const Text('Mark Completed'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // call or open chat — chat already accessible
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatThreadScreen()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                    child: const Text('Contact Mechanic'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}