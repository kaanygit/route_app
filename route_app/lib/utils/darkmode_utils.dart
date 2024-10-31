import 'package:accesible_route/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:accesible_route/bloc/dark_mode/dark_mode_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeUtils {
  static bool isDarkMode(BuildContext context) {
    final darkModeState = context.watch<DarkModeBloc>().state;
    if (darkModeState is DarkModeEnabled) {
      return true; 
    }
    return false; 
  }
}
