import 'package:flutter/material.dart';

class DarkModeScreen extends StatefulWidget {
  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Mode Settings'),
        backgroundColor: isDarkModeEnabled ? Colors.grey[850] : Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.brightness_6, size: 30),
              title: Text('Enable Dark Mode', style: TextStyle(fontSize: 18)),
              trailing: Switch(
                value: isDarkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    isDarkModeEnabled = value;
                  });
                  // Add your dark mode toggle logic here
                },
              ),
            ),
            SizedBox(height: 30),
            isDarkModeEnabled
                ? Text(
                    'Dark Mode is enabled',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                : Text(
                    'Dark Mode is disabled',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
