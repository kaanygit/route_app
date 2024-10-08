import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/bloc/language/language_event.dart'; // Replace with your actual LanguageBloc import

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Language',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final currentLocale = BlocProvider.of<LanguageBloc>(context)
                      .state
                      .locale
                      .languageCode;
                  final newLanguageCode = currentLocale == 'tr' ? 'en' : 'tr';
                  BlocProvider.of<LanguageBloc>(context)
                      .add(ChangeLanguage(newLanguageCode));
                },
                child: Text('Change Language'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
