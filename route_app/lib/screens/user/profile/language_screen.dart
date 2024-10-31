import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/language/language_event.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _currentLanguage = 'tr';
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _currentLanguage =
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_language_screen_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).user_language_screen_title_content,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildLanguageCard(
                    context,
                    title: 'Türkçe',
                    languageCode: 'tr',
                    isDarkMode: isDarkMode,
                  ),
                  _buildLanguageCard(
                    context,
                    title: 'İngilizce',
                    languageCode: 'en',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _showSuccessMessage ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                    SizedBox(width: 8),
                    Text(
                      S.of(context).user_language_screen_title_content_complete,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context,
      {required String title,
      required String languageCode,
      required bool isDarkMode}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(Icons.arrow_forward,
            color: isDarkMode ? Colors.white : Colors.black),
        onTap: () {
          _changeLanguage(context, languageCode);
        },
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      _showSuccessMessage = true;
    });

    BlocProvider.of<LanguageBloc>(context).add(ChangeLanguage(languageCode));

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showSuccessMessage = false;
      });
    });
  }
}
