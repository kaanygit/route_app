import 'package:flutter_bloc/flutter_bloc.dart';
import 'dark_mode_event.dart';
import 'dark_mode_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(DarkModeInitial()) {
    on<DarkModeToggled>(_onDarkMode);
    _loadDarkModePreference();
  }

  Future<void> _onDarkMode(
      DarkModeToggled event, Emitter<DarkModeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

    isDarkMode = !isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);

    if (isDarkMode) {
      emit(DarkModeEnabled());
    } else {
      emit(DarkModeDisabled());
    }
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

    // Dark Mode aktifse, DarkModeEnabled state'ini emit et
    if (isDarkMode) {
      emit(DarkModeEnabled());
    } else {
      emit(DarkModeDisabled());
    }
  }

  void toggleDarkMode() {
    add(DarkModeToggled()); // DarkModeToggled eventini tetikleyerek state'i değiştir
  }
}
