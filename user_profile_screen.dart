import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _editing = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    _nameController.text = user?.displayName ?? 'Muhammad Ibrahim';
    _emailController.text = user?.email ?? 'm.ibrahim@example.com';
    _phoneController.text = user?.phoneNumber ?? '+1 234 567 890';
    _addressController.text = 'Lahore, Pakistan';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    // local save for now; expand to Firestore or Firebase User update later
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
    // optional: update Firebase displayName
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload();
      } catch (_) {}
    }
  }

  Future<void> _sendVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No signed in user')),
      );
      return;
    }
    if (user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already verified')),
      );
      return;
    }

    setState(() => _isVerifying = true);
    try {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification: $e')),
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly || !_editing,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final emailVerified = user?.emailVerified ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_editing) {
                _saveProfile();
              } else {
                setState(() => _editing = true);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 64, color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildTextField(label: 'Full name', controller: _nameController),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              readOnly: true, // email usually not editable here
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Phone',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Home address',
              controller: _addressController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _editing ? _saveProfile : () => setState(() => _editing = true),
                  icon: const Icon(Icons.save),
                  label: Text(_editing ? 'Save' : 'Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: emailVerified || _isVerifying ? null : _sendVerification,
                  icon: const Icon(Icons.verified_user),
                  label: _isVerifying
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(emailVerified ? 'Verified' : 'Verify Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emailVerified ? Colors.grey : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Saved Home'),
                subtitle: Text(_addressController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_location),
                  onPressed: () => setState(() => _editing = true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
