import 'package:accesible_route/bloc/auth/auth_bloc.dart';
import 'package:accesible_route/bloc/auth/auth_event.dart';
import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/main.dart';
import 'package:accesible_route/screens/admin/feedback_view_all_screen.dart';
import 'package:accesible_route/screens/admin/settings_screen.dart';
import 'package:accesible_route/screens/admin/user_management_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reports_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_panel_title),
        actions: [
          IconButton(
              onPressed: () {
                _showExitConfirmation(context, isDarkMode);
              },
              icon: Icon(
                Icons.logout,
                color: isDarkMode ? Colors.white : Colors.black,
              ))
        ],
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAdminCard(
              context,
              title: S.of(context).admin_user_management_title,
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserManagementScreen(),
                  ),
                );
              },
              isDarkMode: isDarkMode,
            ),
            _buildAdminCard(
              context,
              title: S.of(context).admin_reports_title,
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportsScreen(),
                  ),
                );
              },
              isDarkMode: isDarkMode,
            ),
            _buildAdminCard(
              context,
              title: S.of(context).admin_settigs_title,
              icon: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              isDarkMode: isDarkMode,
            ),
            _buildAdminCard(
              context,
              title: S.of(context).admin_feedback_all_title,
              icon: Icons.feedback,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackViewAllScreen(),
                  ),
                );
              },
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: isDarkMode ? Colors.amber : Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).admin_panel_logout_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).admin_panel_logout_content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Border radius
                      ),
                    ),
                    child: Text(
                      S.of(context).app_no,
                      style: fontStyle(15, Colors.black, FontWeight.normal),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _exitApp(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      S.of(context).app_yes,
                      style: fontStyle(15, Colors.black, FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _exitApp(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthSignOutRequested());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return MyApp();
        },
      ),
    );
  }
}
