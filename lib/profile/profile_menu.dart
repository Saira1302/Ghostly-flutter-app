import 'package:flutter/material.dart';


import '../route.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Profile"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.myProfile),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Ghost History"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.ghostHistory),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("Change Theme"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.changeTheme),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Profile Settings"),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profileSettings),
          ),
        ],
      ),
    );
  }
}
