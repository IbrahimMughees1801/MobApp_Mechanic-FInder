import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MechanicJobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job; // <-- FIXED HERE
  const MechanicJobDetailsScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<MechanicJobDetailsScreen> createState() => _MechanicJobDetailsScreenState();
}

class _MechanicJobDetailsScreenState extends State<MechanicJobDetailsScreen> {
  final List<_JobUpdate> _updates = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _callClient() async {
    final phone = widget.job['phone']?.toString() ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No phone number available')));
      return;
    }
    final uri = Uri.parse('tel:$phone');
    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot place call')));
    }
  }

  void _sendUpdate(String text) {
    final message = text.trim();
    if (message.isEmpty) return;
    setState(() {
      _updates.add(_JobUpdate(text: message, time: DateTime.now()));
    });
    _controller.clear();
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.job;

    return Scaffold(
      appBar: AppBar(
        title: Text(j['title']?.toString() ?? 'Job Detail'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: _callClient,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(j['title']?.toString() ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Customer: ${j['customer'] ?? ''}'),
                const SizedBox(height: 4),
                Text('Location: ${j['location'] ?? ''}'),
                const SizedBox(height: 6),
                Text('ETA: ${j['eta'] ?? ''}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Text(j['description']?.toString() ?? '', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _updates.length,
              itemBuilder: (context, i) {
                final u = _updates[i];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(u.text, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(
                          '${u.time.hour.toString().padLeft(2, '0')}:${u.time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendUpdate,
                      decoration: InputDecoration(
                        hintText: 'Send update (e.g. Suspension done)',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () => _sendUpdate(_controller.text),
                    mini: true,
                    backgroundColor: Colors.deepOrange,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobUpdate {
  final String text;
  final DateTime time;

  _JobUpdate({required this.text, required this.time});
}
