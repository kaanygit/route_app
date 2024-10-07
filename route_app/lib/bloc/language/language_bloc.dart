// lib/blocs/language_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:route_app/bloc/language/language_event.dart';
import 'package:route_app/bloc/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('tr'))) {
    on<ChangeLanguage>(_onChangeLanguage);
    _loadLanguage(); // Load the initial language
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'tr';
    emit(LanguageState(Locale(languageCode))); // Emit the loaded state
  }

  void _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    final newState = LanguageState(Locale(event.languageCode));
    emit(newState); // Emit the new state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.languageCode);
  }
}
