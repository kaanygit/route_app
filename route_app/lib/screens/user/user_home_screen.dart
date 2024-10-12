import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:path/path.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_event.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/models/user_model.dart';
import 'package:route_app/screens/user/calender_screen.dart';
import 'package:route_app/screens/user/profile_screen.dart';
import 'package:route_app/screens/user/search_screen.dart';
import 'package:route_app/screens/user/user_home_page_screen.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   // uploadJsonToFirestore();
  // }

  // Future<void> uploadJsonToFirestore() async {
  //   try {
  //     // 1. JSON dosyasını 'assets' klasöründen oku
  //     String jsonString = await rootBundle.loadString('assets/data/data.json');

  //     // 2. JSON'u çözümle (parse et)
  //     final jsonData = jsonDecode(jsonString);

  //     // 3. JSON'dan 'places' anahtarını al
  //     List<dynamic> places = jsonData['places'];

  //     // 4. Firestore referansı
  //     final CollectionReference placesCollection =
  //         FirebaseFirestore.instance.collection('places');

  //     // 5. Veriyi her bir place için Firestore'a ekle
  //     for (var place in places) {
  //       await placesCollection.add({
  //         'key': place['key'],
  //         'title': place['title'],
  //         'content': place['content'],
  //         'image_url': place['image_url'],
  //       });
  //     }

  //     print('Veri Firestore\'a başarıyla yüklendi.');
  //   } catch (e) {
  //     print('Hata: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        // return userBloc;
        if (state is UserLoading) {
          return LoadingScreen();
        } else if (state is UserSuccess) {
          final UserModel user = state.user;
          print(user.profilePhoto);
          print(user.profilePhoto);
          print(user.emailVerified);
          return Scaffold(
            appBar: AppBar(
              title: _buildTitle(user),
            ),
            body: _screens[_selectedItemPosition], // Seçilen ekranı göster
            // backgroundColor: Theme.of(context).bottomAppBarTheme(bottomm),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _selectedItemPosition,
              onTap: (index) {
                setState(() {
                  _selectedItemPosition = index;
                });
              },
              items: [
                // Home Icon
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  selectedColor: Colors.blue,
                ),
                // Calendar Icon
                SalomonBottomBarItem(
                  icon: Icon(Icons.calendar_today),
                  title: Text("Calendar"),
                  selectedColor: Colors.green,
                ),
                // Search Icon
                SalomonBottomBarItem(
                  icon: Icon(Icons.search),
                  title: Text("Search"),
                  selectedColor: Colors.orange,
                ),
                // Profile Icon
                SalomonBottomBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text("Profile"),
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

  Widget _buildTitle(UserModel user) {
    if (_selectedItemPosition == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Discover",
            style: fontStyle(25, Colors.black, FontWeight.bold),
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
            "Calendar",
            style: fontStyle(25, Colors.black, FontWeight.bold),
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
            "Search",
            style: fontStyle(25, Colors.black, FontWeight.bold),
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
            "Your Profile",
            style: fontStyle(25, Colors.black, FontWeight.bold),
          ),
        ],
      );
    }
    return Text('');
  }
}
