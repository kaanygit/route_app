import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/screens/user/profile_screen.dart';
import 'package:route_app/screens/user/user_home_page_screen.dart';
import 'package:route_app/screens/user/test_screen.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';

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

  List<Widget> _buildScreens() {
    return [
      UserHomePageScreen(),
      TestScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return LoadingScreen();
        } else if (state is UserSuccess) {
          final user = state.user;
          print(user);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Icon(Icons.menu),
                  ),
                  Container(
                    child: Text(
                      "Discover",
                      style: fontStyle(25, Colors.black, FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: CircleAvatar(
                      backgroundImage: user.profilePhoto != ""
                          ? NetworkImage(user.profilePhoto) as ImageProvider
                          : AssetImage("assets/images/template.png"),
                    ),
                  ),
                ],
              ),
            ),
            body: _buildScreens()[_selectedItemPosition],
            bottomNavigationBar: SnakeNavigationBar.color(
              behaviour: snakeBarStyle,
              snakeShape: snakeShape,
              shape: bottomBarShape,
              backgroundColor: Colors.black,
              padding: padding,
              snakeViewColor: selectedColor,
              selectedItemColor:
                  snakeShape == SnakeShape.indicator ? selectedColor : null,
              unselectedItemColor: Colors.blueGrey,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              currentIndex: _selectedItemPosition,
              onTap: (index) => setState(() => _selectedItemPosition = index),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: 'Notifications'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Calendar'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              ],
            ),
          );
        } else {
          return SimpleErrorScreen(errorMessage: "Veriler getirilemedi");
        }
      },
    );
  }
}
