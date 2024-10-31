import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/language/language_event.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/auth/intro_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _currentLanguage = 'en';
  bool _showSuccessMessage = false;

  void _changeLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = languageCode;
      _showSuccessMessage = true;
    });

    BlocProvider.of<LanguageBloc>(context).add(ChangeLanguage(languageCode));

    await prefs.setBool("lang_value", true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() async {
        _showSuccessMessage = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const IntroScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showSuccessMessage)
              Text(
                S.of(context).language_selection,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _changeLanguage(context, 'tr'),
                  child: Column(
                    children: [
                      Text(
                        "🇹🇷",
                        style: TextStyle(fontSize: 100),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Türkçe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _changeLanguage(context, 'en'),
                  child: Column(
                    children: [
                      Text(
                        "🇬🇧",
                        style: TextStyle(fontSize: 100),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "English",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
