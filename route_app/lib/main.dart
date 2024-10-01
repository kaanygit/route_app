import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageBloc(),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate, // Localization delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales:
                S.delegate.supportedLocales, // Supported languages
            locale: state.locale, // Set the locale based on the state
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).title), // Localized text
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get the current language code and toggle between Turkish and English
                final currentLocale = BlocProvider.of<LanguageBloc>(context)
                    .state
                    .locale
                    .languageCode;
                final newLanguageCode = currentLocale == 'tr' ? 'en' : 'tr';
                BlocProvider.of<LanguageBloc>(context)
                    .add(ChangeLanguage(newLanguageCode));
              },
              child: Text(S
                  .of(context)
                  .change_language), // Localized change language text
            ),
          ],
        ),
      ),
    );
  }
}
