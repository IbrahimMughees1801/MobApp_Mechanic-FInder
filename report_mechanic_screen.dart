import 'package:flutter/material.dart';

class ReportMechanicScreen extends StatefulWidget {
  const ReportMechanicScreen({Key? key}) : super(key: key);

  @override
  State<ReportMechanicScreen> createState() => _ReportMechanicScreenState();
}

class _ReportMechanicScreenState extends State<ReportMechanicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _locationCtl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    _locationCtl.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    // TODO: persist to backend / firestore
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Mechanic'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(
                  labelText: 'Mechanic / Shop name',
                ),
                validator: (v) => (v ?? '').isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationCtl,
                decoration: const InputDecoration(
                  labelText: 'Location (address or area)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtl,
                decoration: const InputDecoration(
                  labelText: 'Description of issue',
                ),
                maxLines: 4,
                validator: (v) => (v ?? '').isEmpty ? 'Describe the issue' : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _submitting ? null : _submitReport,
                icon: _submitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                label: const Text('Submit Report'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}