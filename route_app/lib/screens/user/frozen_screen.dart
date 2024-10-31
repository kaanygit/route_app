import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/auth/auth_screen.dart';
import 'package:accesible_route/screens/user/profile/feedback_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountFrozenScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).frozenscreen_frozen_title,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).frozenscreen_frozen_title_content,
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FeedbackScreen()));
              },
              icon: Icon(Icons.feedback),
              label: Text(S.of(context).user_feedback_screen_titles),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _auth.signOut();
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("hasUserData", false);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AuthScreen()));
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Çıkış Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red[700] : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
