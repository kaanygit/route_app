import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/auth/auth_bloc.dart';
import 'package:route_app/bloc/auth/auth_event.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/bloc/language/language_event.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/generated/l10n.dart';
import 'package:route_app/models/user_model.dart';
import 'package:route_app/screens/user/profile/dark_mode_screen.dart';
import 'package:route_app/screens/user/profile/faq_screen.dart';
import 'package:route_app/screens/user/profile/language_screen.dart';
import 'package:route_app/screens/user/profile/personal_information_screen.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                            "Hello, ${user.displayName}",
                            style: fontStyle(18, Colors.black, FontWeight.bold),
                          ),
                          Text(
                            "${user.email}",
                            style:
                                fontStyle(16, Colors.grey, FontWeight.normal),
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
                      profileBoxes(context, "Personal Information",
                          Icons.account_circle, 0),
                      profileBoxes(context, "FAQ", Icons.comment, 1),
                      profileBoxes(context, "Dark Mode", Icons.dark_mode, 2),
                      profileBoxes(context, "Language", Icons.language, 3),
                      profileBoxes(context, "Logout", Icons.logout, 4),
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

  Column profileBoxes(
      BuildContext context, String title, IconData getIcon, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (index == 0) {
              // index 0 için ekran yönlendirmesi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PersonalInformationScreen(); // index 0'a özel ekran
                  },
                ),
              );
            } else if (index == 1) {
              // index 1 için ekran yönlendirmesi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FaqScreen(); // index 1'e özel ekran
                  },
                ),
              );
            } else if (index == 2) {
              // index 2 için ekran yönlendirmesi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DarkModeScreen(); // index 2'ye özel ekran
                  },
                ),
              );
            } else if (index == 3) {
              // index 3 için ekran yönlendirmesi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LanguageScreen(); // index 3'e özel ekran
                  },
                ),
              );
            } else if (index == 4) {
              print("test");
              _showExitConfirmation(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
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

void _showExitConfirmation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(16)), // Üst kısım için border radius
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Çıkış Yapmak İstiyor Musunuz?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Uygulamadan çıkış yaparsanız, tüm ilerlemeleriniz kaybolacaktır. Devam etmek istiyor musunuz?",
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
                    Navigator.pop(context); // Hayır'a basılınca menüyü kapat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Buton arka plan rengi
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Border radius
                    ),
                  ),
                  child: Text("Hayır"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Evet'e basılınca yapılacak işlemler
                    _exitApp(context); // Çıkış işlemi burada yapılacak
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Buton arka plan rengi
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Border radius
                    ),
                  ),
                  child: Text("Evet"),
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
  // Uygulamadan çıkış yapma işlemleri burada yapılacak
  print("Uygulamadan çıkış yapılıyor...");
  BlocProvider.of<AuthBloc>(context).add(AuthSignOutRequested());
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
