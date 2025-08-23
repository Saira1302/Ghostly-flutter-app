import 'package:firebase_connection_app/profile/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Theme"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select a Theme Mode",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Light Mode Button
            ElevatedButton.icon(
              onPressed: () {
                themeProvider.toggleTheme(false); // Light Mode
              },
              icon: Icon(Icons.light_mode,
                  color: themeProvider.isDarkMode ? Colors.grey : Colors.amber),
              label: Text(
                'Light Mode',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.grey : Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                themeProvider.isDarkMode ? Colors.grey[300] : Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),

            const SizedBox(height: 20),

            // Dark Mode Button
            ElevatedButton.icon(
              onPressed: () {
                themeProvider.toggleTheme(true); // Dark Mode
              },
              icon: Icon(Icons.dark_mode,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey),
              label: Text(
                'Dark Mode',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                themeProvider.isDarkMode ? Colors.black : Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
