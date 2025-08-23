import 'package:flutter/material.dart';

import '../route.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Terms & Conditions"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.terms),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.privacy),
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text("Report a Bug"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.bugReport),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About App"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.about),
          ),
        ],
      ),
    );
  }
}
