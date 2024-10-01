// lib/blocs/language_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the events for the LanguageBloc
abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;

  ChangeLanguage(this.languageCode);
}

// Define the states for the LanguageBloc
class LanguageState {
  final Locale locale;

  LanguageState(this.locale);
}

// Define the LanguageBloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('tr'))) {
    on<ChangeLanguage>(_onChangeLanguage);
    _loadLanguage(); // Load the initial language
  }

  // Load the language from SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'tr';
    emit(LanguageState(Locale(languageCode))); // Emit the loaded state
  }

  // Define the event handler for ChangeLanguage
  void _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    final newState = LanguageState(Locale(event.languageCode));
    emit(newState); // Emit the new state

    // Save the selected language in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.languageCode);
  }
}
