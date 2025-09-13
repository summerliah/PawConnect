import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.visibility, color: Colors.orange),
            title: const Text('Profile Visibility'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.orange,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.orange),
            title: const Text('Photo Privacy'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.orange,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.orange),
            title: const Text('Location Sharing'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
