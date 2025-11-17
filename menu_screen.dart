import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';
import 'report_mechanic_screen.dart';
import 'safety_alert_screen.dart';
import 'settings_screen.dart';
import 'help_feedback_screen.dart';
import 'apply_mechanic_screen.dart'; // added import

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          // New: apply flow accessible from menu
          ListTile(
            leading: const Icon(Icons.handshake, color: Colors.deepOrange),
            title: const Text('Apply to be a mechanic'),
            subtitle: const Text('Submit your application'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApplyMechanicScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.report, color: Colors.redAccent),
            title: const Text('Report Mechanic'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportMechanicScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blueGrey),
            title: const Text('Previous Requests'),
            onTap: () => _openPlaceholder(context, 'Previous Requests'),
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.deepPurple),
            title: const Text('Safety'),
            subtitle: const Text('Alert safety services'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SafetyAlertScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.teal),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpFeedbackScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text('Log out'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Text('$title - Coming soon', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}