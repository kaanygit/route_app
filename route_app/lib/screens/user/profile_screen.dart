import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/bloc/language/language_event.dart';
import 'package:route_app/generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).title),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final currentLocale = BlocProvider.of<LanguageBloc>(context)
                    .state
                    .locale
                    .languageCode;
                final newLanguageCode = currentLocale == 'tr' ? 'en' : 'tr';
                BlocProvider.of<LanguageBloc>(context)
                    .add(ChangeLanguage(newLanguageCode));
              },
              child: Text(S.of(context).change_language),
            ),
          ],
        ),
      ),
    );
  }
}
