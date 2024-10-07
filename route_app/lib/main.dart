import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:route_app/bloc/auth/auth_bloc.dart';
import 'package:route_app/bloc/auth/auth_event.dart';
import 'package:route_app/bloc/auth/auth_state.dart';
import 'package:route_app/bloc/language/language_bloc.dart';
import 'package:route_app/bloc/language/language_state.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_event.dart';
import 'package:route_app/firebase_options.dart';
import 'package:route_app/screens/admin/admin_home_screen.dart';
import 'package:route_app/screens/auth/auth_screen.dart';
import 'package:route_app/screens/auth/intro_screen.dart';
import 'package:route_app/screens/user/user_home_screen.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider<UserBloc>(
            create: (context) => UserBloc()..add(UserInformationGets())),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(AuthCheckRequested())),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: state.locale,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: LoadingScreen(),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            return IntroScreen();
          } else {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Scaffold(
                    body: LoadingScreen(),
                  );
                } else if (state is Authenticated) {
                  return FutureBuilder(
                    future: _getAdminController(),
                    builder: (context, adminSnapshot) {
                      if (adminSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Scaffold(
                          body: LoadingScreen(),
                        );
                      }
                      if (adminSnapshot.hasData) {
                        if (adminSnapshot.data == true) {
                          return AdminHomeScreen();
                        } else {
                          return UserHomeScreen();
                        }
                      } else {
                        return Scaffold(
                          body: SimpleErrorScreen(
                            errorMessage: "Admin kontrolü hatalı.",
                          ),
                        );
                      }
                    },
                  );
                } else if (state is Unauthenticated) {
                  return AuthScreen();
                } else {
                  return Scaffold(
                    body: SimpleErrorScreen(
                      errorMessage: "Hatalı işlem.",
                    ),
                  );
                }
              },
            );
          }
        } else {
          return Scaffold(
            body: SimpleErrorScreen(
              errorMessage: "KOMPLE HATALI SAYFA",
            ),
          );
        }
      },
    );
  }

  Future<bool> _checkFirstLaunch() async {
    print("İntro kontrol noktası");
    final prefs = await SharedPreferences.getInstance();
    final bool? isFirstLaunchCheckValue = prefs.getBool("intro_value");

    if (isFirstLaunchCheckValue == null || isFirstLaunchCheckValue == false) {
      print("Tanıtım gösterilecek.");
      return false;
    } else {
      print("Tanıtım daha önce gösterildi.");
      return true;
    }
  }

  Future<bool> _getAdminController() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && doc['isAdmin'] == true) {
          return true; // Admin
        }
      }
      return false;
    } catch (e) {
      print('Admin kontrol hatası: $e');
      return false;
    }
  }
}
