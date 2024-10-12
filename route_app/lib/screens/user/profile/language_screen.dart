import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/bloc/language/language_event.dart';
import 'package:route_app/generated/l10n.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dil Ayarları'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dil Seçin',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Türkçe',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        _changeLanguage(context, 'tr');
                      },
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'İngilizce',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        _changeLanguage(context, 'en');
                      },
                    ),
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
                      'Dil değişti!',
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

  void _changeLanguage(BuildContext context, String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      _showSuccessMessage = true;
    });

    BlocProvider.of<LanguageBloc>(context).add(ChangeLanguage(languageCode));

    // Mesajı 2 saniye sonra gizlemek için bir zamanlayıcı
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showSuccessMessage = false;
      });
    });
  }
}
