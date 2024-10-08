import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/models/user_model.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';
import 'package:route_app/widgets/text_field.dart';

class UserHomePageScreen extends StatefulWidget {
  const UserHomePageScreen({super.key});

  @override
  State<UserHomePageScreen> createState() => _UserHomePageScreenState();
}

class _UserHomePageScreenState extends State<UserHomePageScreen> {
  late int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return LoadingScreen();
        } else if (state is UserSuccess) {
          final UserModel user = state.user;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          child: Text("Popular",
                              style: fontStyle(
                                  16,
                                  _selectedIndex == 0
                                      ? Colors.amber
                                      : Colors.black,
                                  _selectedIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: Text("Featured",
                              style: fontStyle(
                                  16,
                                  _selectedIndex == 1
                                      ? Colors.amber
                                      : Colors.black,
                                  _selectedIndex == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          child: Text("Most Visited",
                              style: fontStyle(
                                  16,
                                  _selectedIndex == 2
                                      ? Colors.amber
                                      : Colors.black,
                                  _selectedIndex == 2
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          placesContainer(),
                          placesContainer(),
                          placesContainer(),
                          placesContainer(),
                          placesContainer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recommended",
                          style: fontStyle(18, Colors.black, FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            print("View All");
                          },
                          child: Text(
                            "View All",
                            style:
                                fontStyle(14, Colors.black, FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap:
                          true, // GridView'ın yüksekliğini sınırlamak için
                      physics:
                          NeverScrollableScrollPhysics(), // GridView'ı kaydırılabilir yapma
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 10, // 10 öğe olacak
                      itemBuilder: (context, index) {
                        return recommendPlacesContainer();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SimpleErrorScreen(
              errorMessage: "Veriler Getirilirken Hata oluştu");
        }
      },
    );
  }

  Row placesContainer() {
    return Row(
      children: [
        Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.purple.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Alt kısımdan hizalama
              children: [
                // Alt kısımda yer alacak içerikler
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Sol ve sağa yerleştir
                  children: [
                    // Sol taraf (İsim ve Yıldızlar)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Yer İsmi", // Yer adı
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < 4
                                  ? Colors.yellow
                                  : Colors
                                      .white, // 4 yıldız sarı, geri kalan beyaz
                            );
                          }),
                        ),
                      ],
                    ),

                    // Sağ taraf (Kalp Butonu)
                    IconButton(
                      icon: Icon(Icons.favorite,
                          color: Colors.red), // Kalp simgesi
                      onPressed: () {
                        // Butona basıldığında yapılacak işlem
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Container recommendPlacesContainer() {
    return Container(
      width: 50, // Küçük boyut
      height: 30, // Küçük boyut
      decoration: BoxDecoration(
        color: Colors.purple.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol taraf (İsim ve Yıldızlar)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yer İsmi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13, // Küçük yazı tipi
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < 5
                              ? Colors.yellow
                              : Colors.white, // Yıldızlar
                          size: 15, // Küçük yıldız boyutu
                        );
                      }),
                    ),
                  ],
                ),
                // Sağ taraf (Kalp Butonu)
                IconButton(
                  icon: Icon(Icons.favorite,
                      color: Colors.red, size: 12), // Küçük ikon
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
