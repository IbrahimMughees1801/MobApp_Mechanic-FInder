import 'package:flutter/material.dart';
import 'mechanic_home_screen.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({Key? key}) : super(key: key);

  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Mechanic Name');
  final _serviceCtrl = TextEditingController(text: 'Services offered');
  bool _editing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _serviceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated (local)')));
    // TODO: save to backend / Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Profile'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_editing) _save();
              else setState(() => _editing = true);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 44, child: const Icon(Icons.build, size: 40)),
            const SizedBox(height: 12),
            TextField(controller: _nameCtrl, readOnly: !_editing, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: _serviceCtrl, readOnly: !_editing, decoration: const InputDecoration(labelText: 'Services')),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Verification status'),
              subtitle: const Text('Not verified (skeleton)'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Apply verification')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicHomeScreen()));
        },
      ),
    );
  }
}
