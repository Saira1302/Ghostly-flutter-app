import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Change Username"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Update Email"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Reset Password"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
