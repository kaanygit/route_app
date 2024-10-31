import 'package:accesible_route/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:accesible_route/bloc/dark_mode/dark_mode_state.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DarkModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_dark_mode_screen_title),
      ),
      body: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) {
          bool isDarkMode = state is DarkModeEnabled;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).user_dark_mode_screen_appearance,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                ListTile(
                  leading: Icon(
                    Icons.brightness_6,
                    size: 30,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    S.of(context).user_dark_mode_screen_title_content1,
                    style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      BlocProvider.of<DarkModeBloc>(context).toggleDarkMode();
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  isDarkMode
                      ? 'Dark Mode is enabled. Enjoy the darker theme!'
                      : 'Dark Mode is disabled. Enjoy the lighter theme!',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
