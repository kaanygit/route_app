import 'package:accesible_route/bloc/language/language_event.dart';
import 'package:accesible_route/bloc/language/language_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('tr'))) {
    on<ChangeLanguage>(_onChangeLanguage);
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'tr';
    emit(LanguageState(Locale(languageCode)));
  }

  void _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    final newState = LanguageState(Locale(event.languageCode));
    emit(newState);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.languageCode);
  }
}
