import 'package:flutter/material.dart';
import 'single_notification.dart';
import 'notification_setting.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationSettings()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a sample notification.'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SingleNotificationScreen(
                    title: 'Notification ${index + 1}',
                    content: 'Details of notification ${index + 1}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
