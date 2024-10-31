import 'package:accesible_route/bloc/auth/auth_bloc.dart';
import 'package:accesible_route/bloc/auth/auth_event.dart';
import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_state.dart';
import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/main.dart';
import 'package:accesible_route/models/user_model.dart';
import 'package:accesible_route/screens/user/maps/maps.dart';
import 'package:accesible_route/screens/user/profile/dark_mode_screen.dart';
import 'package:accesible_route/screens/user/profile/faq_screen.dart';
import 'package:accesible_route/screens/user/profile/feedback_screen.dart';
import 'package:accesible_route/screens/user/profile/language_screen.dart';
import 'package:accesible_route/screens/user/profile/personal_information_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/error_screen.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);
    setState(() {
      isDarkMode = !isDarkMode;
    });
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return LoadingScreen();
      } else if (state is UserSuccess) {
        final UserModel user = state.user;

        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundImage: user.profilePhoto != ""
                              ? NetworkImage(user.profilePhoto) as ImageProvider
                              : AssetImage("assets/images/template.png"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${S.of(context).user_profile_hi}, ${user.displayName}",
                            style: fontStyle(
                                18,
                                isDarkMode ? Colors.black : Colors.white,
                                FontWeight.bold),
                          ),
                          Text(
                            "${user.email}",
                            style: fontStyle(
                                16,
                                isDarkMode ? Colors.grey : Colors.white,
                                FontWeight.normal),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      profileBoxes(
                          context,
                          S.of(context).user_profile_personal_information_title,
                          Icons.account_circle,
                          0,
                          isDarkMode),
                      profileBoxes(
                          context,
                          S.of(context).user_profile_faq_title,
                          Icons.comment,
                          1,
                          isDarkMode),
                      profileBoxes(
                          context,
                          S.of(context).user_profile_darkmode_title,
                          Icons.dark_mode,
                          2,
                          isDarkMode),
                      profileBoxes(
                          context,
                          S.of(context).user_profile_language_title,
                          Icons.language,
                          3,
                          isDarkMode),
                      profileBoxes(
                          context,
                          S.of(context).user_profile_feedback_title,
                          Icons.feedback,
                          4,
                          isDarkMode),
                      profileBoxes(
                          context,
                          S.of(context).user_profile_logout_title,
                          Icons.logout,
                          5,
                          isDarkMode),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        return SimpleErrorScreen(
            errorMessage: "Profil Verileri Getirilirken Bir Hata Oluştu : (");
      }
    });
  }

  Column profileBoxes(BuildContext context, String title, IconData getIcon,
      int index, bool isDarkMode) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PersonalInformationScreen();
                  },
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FaqScreen();
                  },
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DarkModeScreen();
                  },
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LanguageScreen();
                  },
                ),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FeedbackScreen();
                  },
                ),
              );
            } else if (index == 5) {
              print("test");
              List<int> shortestRoute = findShortestRoute(10);
              print(shortestRoute);
              _showExitConfirmation(context, isDarkMode);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Color(0xFFF8F8FF),
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: fontStyle(16, Colors.black, FontWeight.bold),
                ),
                Icon(
                  getIcon,
                  size: 25,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

void _showExitConfirmation(BuildContext context, bool isDarkMode) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).user_profile_logout_show_title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              S.of(context).user_profile_logout_show_title_content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
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
                      borderRadius: BorderRadius.circular(16), // Border radius
                    ),
                  ),
                  child: Text(S.of(context).app_no,
                      style: fontStyle(15, Colors.black, FontWeight.normal)),
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




// ElevatedButton(
//               onPressed: () {
//                 final currentLocale = BlocProvider.of<LanguageBloc>(context)
//                     .state
//                     .locale
//                     .languageCode;
//                 final newLanguageCode = currentLocale == 'tr' ? 'en' : 'tr';
//                 BlocProvider.of<LanguageBloc>(context)
//                     .add(ChangeLanguage(newLanguageCode));
//               },
//               child: Text(S.of(context).change_language),
//             ),
