import 'package:flutter/material.dart';
import 'mechanic_home_screen.dart'; // added import

class ApplyMechanicScreen extends StatefulWidget {
  const ApplyMechanicScreen({Key? key}) : super(key: key);

  @override
  State<ApplyMechanicScreen> createState() => _ApplyMechanicScreenState();
}

class _ApplyMechanicScreenState extends State<ApplyMechanicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _vehicleCtl = TextEditingController();
  bool _submitting = false;
  bool _submitted = false; // track whether user has applied

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _vehicleCtl.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
    });

    // Placeholder: replace with Firestore/API call later
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _submitting = false;
      _submitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted. You will be notified about verification status.')),
    );

    // TEMP FLOW: immediately route user to mechanic home until backend verification is implemented
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MechanicHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply to be a mechanic'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _submitted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 72, color: Colors.green),
                  const SizedBox(height: 12),
                  const Text(
                    'Application received',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('We will review your application and notify you when verified.'),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      // allow user to edit or re-submit if needed
                      setState(() => _submitted = false);
                    },
                    child: const Text('Edit application'),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      'Fill basic details to apply. This is a skeleton — verification and approval will be handled via backend.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtl,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtl,
                      decoration: const InputDecoration(labelText: 'Phone number'),
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Enter phone' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _vehicleCtl,
                      decoration: const InputDecoration(labelText: 'Vehicle / Services offered'),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.upload_file),
                      title: const Text('Upload license / certificate (placeholder)'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File picker not implemented (skeleton)')),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submitApplication,
                      child: _submitting
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Application'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}