import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/user/profile/dark_mode_screen.dart';
import 'package:accesible_route/screens/user/profile/language_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_settigs_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? Colors.amber : Colors.deepPurple,
            ),
            title: Text(
              S.of(context).admin_settigs_dark_mode_title,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            subtitle: Text(
              S.of(context).admin_settigs_dark_mode_content,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DarkModeScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.language,
                color: isDarkMode ? Colors.amber : Colors.deepPurple),
            title: Text(
              S.of(context).admin_settigs_language_title,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              S.of(context).admin_settigs_language_content,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
