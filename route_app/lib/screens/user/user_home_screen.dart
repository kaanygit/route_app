import 'dart:convert';
import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_state.dart';
import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/user_model.dart';
import 'package:accesible_route/screens/user/calender_screen.dart';
import 'package:accesible_route/screens/user/profile_screen.dart';
import 'package:accesible_route/screens/user/search_screen.dart';
import 'package:accesible_route/screens/user/user_home_page_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/error_screen.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedItemPosition = 0;

  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  SnakeShape snakeShape = SnakeShape.rectangle;
  ShapeBorder? bottomBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  );
  EdgeInsets padding = EdgeInsets.all(12);

  Color selectedColor = Colors.blueAccent;

  List<Widget> _screens = [
    UserHomePageScreen(),
    CalenderScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // uploadJsonToFirestore();
  }

  Future<void> uploadJsonToFirestore() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/data.json');

      final jsonData = jsonDecode(jsonString);

      List<dynamic> places = jsonData['places'];

      final CollectionReference placesCollection =
          FirebaseFirestore.instance.collection('places');

      for (var place in places) {
        await placesCollection.add({
          "key": place['key'],
          "titleTr": place['title_tr'],
          "titleEng": place['title_eng'],
          "contentTr": place['content_tr'],
          "contentEng": place['content_eng'],
          "imageUrl": place['image_url'],
          "latitude": place['latitude']?.toDouble(),
          "longitude": place['longitude']?.toDouble(),
        });
      }

      print('Veri Firestore\'a başarıyla yüklendi.');
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    setState(() {
      isDarkMode = !isDarkMode;
    });
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return LoadingScreen();
        } else if (state is UserSuccess) {
          final UserModel user = state.user;
          print(user.profilePhoto);
          print(user.profilePhoto);
          print(user.emailVerified);
          return Scaffold(
            appBar: AppBar(
              title: _buildTitle(user, isDarkMode, context),
            ),
            body: _screens[_selectedItemPosition],
            // backgroundColor: Theme.of(context).bottomAppBarTheme(bottomm),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _selectedItemPosition,
              onTap: (index) {
                setState(() {
                  _selectedItemPosition = index;
                });
              },
              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text(S.of(context).user_bottom_home),
                  selectedColor: Colors.blue,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.calendar_today),
                  title: Text(S.of(context).user_bottom_calender),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.search),
                  title: Text(S.of(context).user_bottom_search),
                  selectedColor: Colors.orange,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text(S.of(context).user_bottom_profile),
                  selectedColor: Colors.purple,
                ),
              ],
            ),
          );
        } else if (state is UserFailure) {
          return SimpleErrorScreen(
              errorMessage: 'Hatalı veri gelmedi : ${state.error}');
        } else {
          return SimpleErrorScreen(errorMessage: "Veriler getirilemedi : ");
        }
      },
    );
  }

  Widget _buildTitle(UserModel user, bool isDarkMode, BuildContext context) {
    if (_selectedItemPosition == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).user_discover_title,
            style: fontStyle(
                25, isDarkMode ? Colors.black : Colors.white, FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: user.profilePhoto != ""
                ? NetworkImage(user.profilePhoto)
                : AssetImage("assets/images/template.png"),
          ),
        ],
      );
    } else if (_selectedItemPosition == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).user_bottom_calender,
            style: fontStyle(
                25, isDarkMode ? Colors.black : Colors.white, FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: user.profilePhoto != ""
                ? NetworkImage(user.profilePhoto) as ImageProvider
                : AssetImage("assets/images/template.png"),
          ),
        ],
      );
    } else if (_selectedItemPosition == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).user_bottom_search,
            style: fontStyle(
                25, isDarkMode ? Colors.black : Colors.white, FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: user.profilePhoto != ""
                ? NetworkImage(user.profilePhoto)
                : AssetImage("assets/images/template.png"),
          ),
        ],
      );
    } else if (_selectedItemPosition == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            S.of(context).user_profile_title,
            style: fontStyle(
                25, isDarkMode ? Colors.black : Colors.white, FontWeight.bold),
          ),
        ],
      );
    }
    return Text('');
  }
}
