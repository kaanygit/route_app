import 'package:accesible_route/bloc/auth/auth_bloc.dart';
import 'package:accesible_route/bloc/auth/auth_event.dart';
import 'package:accesible_route/bloc/auth/auth_state.dart';
import 'package:accesible_route/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:accesible_route/bloc/dark_mode/dark_mode_state.dart';
import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/language/language_state.dart';
import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_event.dart';
import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_event.dart';
import 'package:accesible_route/firebase_options.dart';
import 'package:accesible_route/screens/admin/admin_home_screen.dart';
import 'package:accesible_route/screens/auth/auth_screen.dart';
import 'package:accesible_route/screens/auth/intro_screen.dart';
import 'package:accesible_route/screens/auth/language_selection_screen.dart';
import 'package:accesible_route/screens/user/frozen_screen.dart';
import 'package:accesible_route/screens/user/location_permission_screen.dart';
import 'package:accesible_route/screens/user/user_home_screen.dart';
import 'package:accesible_route/widgets/error_screen.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase başlatma hatası: $e');
  }
  Future<void> clearAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()..add(UserInformationGets()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
        BlocProvider<PlacesBloc>(
          create: (context) => PlacesBloc()
            ..add(PlacesInformationGetAndSets())
            ..add(PlacesInformationGets()),
        ),
        BlocProvider<DarkModeBloc>(
          create: (_) => DarkModeBloc(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<DarkModeBloc, DarkModeState>(
            builder: (context, darkModeState) {
              Locale currentLocale = languageState.locale;

              return MaterialApp(
                theme: darkModeState is DarkModeEnabled
                    ? ThemeData.dark().copyWith(
                        bottomAppBarTheme:
                            BottomAppBarTheme(color: Colors.black),
                        appBarTheme: AppBarTheme(color: Color(0xFF212125)),
                        scaffoldBackgroundColor: Color(0xFF212121),
                      )
                    : ThemeData.light().copyWith(
                        bottomAppBarTheme:
                            BottomAppBarTheme(color: Colors.white),
                        appBarTheme: AppBarTheme(color: Colors.white),
                        scaffoldBackgroundColor: Colors.white),
                themeMode: ThemeMode.system,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: currentLocale,
                home: AuthWrapper(),
              );
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  AuthWrapper({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkSecondLunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (snapshot.hasError) {
            return SimpleErrorScreen(
              errorMessage: "KOMPLE HATALI SAYFA",
            );
          }

          if (snapshot.hasData && snapshot.data == false) {
            return LanguageSelectionScreen();
          } else {
            return FutureBuilder(
                future: _checkFirstLaunch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  if (snapshot.hasError) {
                    return SimpleErrorScreen(
                      errorMessage: "KOMPLE HATALI SAYFA",
                    );
                  }
                  if (snapshot.hasData && snapshot.data == false) {
                    return IntroScreen();
                  } else {
                    return FutureBuilder(
                        future: _getLocationController(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingScreen();
                          }
                          if (snapshot.hasError) {
                            return SimpleErrorScreen(
                                errorMessage: "Hata oluştu");
                          }
                          if (snapshot.hasData && snapshot.hasData == true) {
                            return BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return LoadingScreen();
                                } else if (state is Authenticated) {
                                  return FutureBuilder(
                                    future: _getAdminController(),
                                    builder: (context, adminSnapshot) {
                                      if (adminSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return LoadingScreen();
                                      }

                                      if (adminSnapshot.hasData) {
                                        return adminSnapshot.data == true
                                            ? AdminHomeScreen()
                                            : FutureBuilder(
                                                future: _firestore
                                                    .collection('users')
                                                    .doc(_auth.currentUser!.uid)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return LoadingScreen();
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Scaffold(
                                                      body: Center(
                                                        child: Text(
                                                            'Bir hata oluştu: ${snapshot.error}'),
                                                      ),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    var userData =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>?;

                                                    if (userData == null) {
                                                      return Scaffold(
                                                        body: Center(
                                                          child: Text(
                                                              'Kullanıcı verisi bulunamadı.'),
                                                        ),
                                                      );
                                                    }

                                                    bool isAccountFrozen = userData[
                                                            'isAccountFrozen'] ??
                                                        false;

                                                    if (isAccountFrozen) {
                                                      return AccountFrozenScreen();
                                                    } else {
                                                      bool isAdmin =
                                                          userData['isAdmin'] ??
                                                              false;

                                                      return isAdmin
                                                          ? AdminHomeScreen()
                                                          : UserHomeScreen();
                                                    }
                                                  }
                                                  return Container();
                                                },
                                              );
                                      } else {
                                        return SimpleErrorScreen(
                                          errorMessage:
                                              "Admin kontrolü hatalı.",
                                        );
                                      }
                                    },
                                  );
                                } else if (state is Unauthenticated) {
                                  return AuthScreen();
                                } else {
                                  return SimpleErrorScreen(
                                    errorMessage: "Hatalı işlem.",
                                  );
                                }
                              },
                            );
                          } else {
                            return LocationPermissionScreen();
                          }
                        });
                  }
                });
          }
        },
      ),
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

  Future<bool> _checkSecondLunch() async {
    print("Language kontrol noktası");
    final prefs = await SharedPreferences.getInstance();
    final bool? isFirstLaunchCheckValue = prefs.getBool("lang_value");

    if (isFirstLaunchCheckValue == null || isFirstLaunchCheckValue == false) {
      print("Language gösterilecek.");
      return false;
    } else {
      print("Language daha önce gösterildi.");
      return true;
    }
  }

  Future<bool> _getLocationController() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      } else {
        return false;
      }
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




                    // BlocBuilder<AuthBloc, AuthState>(
                    //   builder: (context, state) {
                    //     if (state is AuthLoading) {
                    //       return LoadingScreen();
                    //     } else if (state is Authenticated) {
                    //       return FutureBuilder(
                    //         future: _getAdminController(),
                    //         builder: (context, adminSnapshot) {
                    //           if (adminSnapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return LoadingScreen();
                    //           }

                    //           if (adminSnapshot.hasData) {
                    //             return adminSnapshot.data == true
                    //                 ? AdminHomeScreen()
                    //                 : FutureBuilder(
                    //                     future: _firestore
                    //                         .collection('users')
                    //                         .doc(_auth.currentUser!.uid)
                    //                         .get(),
                    //                     builder: (context, snapshot) {
                    //                       if (snapshot.connectionState ==
                    //                           ConnectionState.waiting) {
                    //                         return LoadingScreen();
                    //                       }
                    //                       if (snapshot.hasError) {
                    //                         return Scaffold(
                    //                           body: Center(
                    //                             child: Text(
                    //                                 'Bir hata oluştu: ${snapshot.error}'),
                    //                           ),
                    //                         );
                    //                       }
                    //                       if (snapshot.hasData) {
                    //                         var userData = snapshot.data!.data()
                    //                             as Map<String, dynamic>?;

                    //                         if (userData == null) {
                    //                           return Scaffold(
                    //                             body: Center(
                    //                               child: Text(
                    //                                   'Kullanıcı verisi bulunamadı.'),
                    //                             ),
                    //                           );
                    //                         }

                    //                         bool isAccountFrozen =
                    //                             userData['isAccountFrozen'] ??
                    //                                 false;

                    //                         if (isAccountFrozen) {
                    //                           return AccountFrozenScreen();
                    //                         } else {
                    //                           bool isAdmin =
                    //                               userData['isAdmin'] ?? false;

                    //                           return isAdmin
                    //                               ? AdminHomeScreen()
                    //                               : UserHomeScreen();
                    //                         }
                    //                       }
                    //                       return Container();
                    //                     },
                    //                   );
                    //           } else {
                    //             return SimpleErrorScreen(
                    //               errorMessage: "Admin kontrolü hatalı.",
                    //             );
                    //           }
                    //         },
                    //       );
                    //     } else if (state is Unauthenticated) {
                    //       return AuthScreen();
                    //     } else {
                    //       return SimpleErrorScreen(
                    //         errorMessage: "Hatalı işlem.",
                    //       );
                    //     }
                    //   },
                    // );