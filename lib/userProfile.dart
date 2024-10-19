import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new_rounded),
              tooltip: 'Signout',
            ),
          ],
        ),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
