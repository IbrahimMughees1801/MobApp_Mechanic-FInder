import 'package:flutter/material.dart';
import 'support_chat_screen.dart'; // added import

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageCtl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _messageCtl.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1)); // placeholder
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback sent. Thank you!')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Describe your issue or feedback. We will review and respond.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageCtl,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your message here...',
                ),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _sending ? null : _sendFeedback,
                icon: _sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                label: const Text('Send Feedback'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 12),
              // Chat with Support button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SupportChatScreen()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat with Support'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}