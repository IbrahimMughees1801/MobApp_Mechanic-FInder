import 'package:flutter/material.dart';
import 'CustomerJobTrackingScreen.dart';

class RequestMechanicScreen extends StatefulWidget {
  const RequestMechanicScreen({Key? key}) : super(key: key);

  @override
  State<RequestMechanicScreen> createState() => _RequestMechanicScreenState();
}

class _RequestMechanicScreenState extends State<RequestMechanicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _locationCtl = TextEditingController();
  final _descCtl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtl.dispose();
    _locationCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final job = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleCtl.text.trim(),
      'location': _locationCtl.text.trim(),
      'description': _descCtl.text.trim(),
      'status': 'requested',
      'eta': 'TBD',
      'mechanic': '',
    };

    await Future.delayed(const Duration(seconds: 1)); // UI-only placeholder

    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted')));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerJobTrackingScreen(job: job)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Mechanic'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtl,
                decoration: const InputDecoration(labelText: 'Job title (e.g. Flat tire)'),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationCtl,
                decoration: const InputDecoration(labelText: 'Location / Address'),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _submitting ? null : _submitRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                child: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}