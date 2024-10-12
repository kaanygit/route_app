import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/places/places_bloc.dart';
import 'package:route_app/bloc/places/places_state.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/models/place_model.dart';
import 'package:route_app/models/user_model.dart';
import 'package:route_app/screens/user/place_screen.dart';
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
          return BlocBuilder<PlacesBloc, PlacesState>(
              builder: (context, state) {
            if (state is PlacesLoading) {
              return LoadingScreen();
            } else if (state is PlacesSuccess) {
              final List<Place> places = state.places;
              List<Place> randomPlaces = _getRandomPlaces(places, 10);

              print(places.length);
              return Scaffold(
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
                              placesContainer(places[1], 1, context),
                              placesContainer(places[3], 3, context),
                              placesContainer(places[5], 5, context),
                              placesContainer(places[7], 7, context),
                              placesContainer(places[9], 9, context),
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
                              style:
                                  fontStyle(18, Colors.black, FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                print("View All");
                              },
                              child: Text(
                                "View All",
                                style: fontStyle(
                                    14, Colors.black, FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: randomPlaces
                              .length, // Rastgele seçilen öğe sayısı
                          itemBuilder: (context, index) {
                            return recommendPlacesContainer(
                                randomPlaces[index], context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SimpleErrorScreen(
                errorMessage: 'Place verileri getirlirke hata oluştu',
              );
            }
          });
          // return Scaffold(
          //   body: SingleChildScrollView(
          //     child: Container(
          //       padding: EdgeInsets.all(16),
          //       child: Column(
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               TextButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     _selectedIndex = 0;
          //                   });
          //                 },
          //                 child: Text("Popular",
          //                     style: fontStyle(
          //                         16,
          //                         _selectedIndex == 0
          //                             ? Colors.amber
          //                             : Colors.black,
          //                         _selectedIndex == 0
          //                             ? FontWeight.bold
          //                             : FontWeight.normal)),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     _selectedIndex = 1;
          //                   });
          //                 },
          //                 child: Text("Featured",
          //                     style: fontStyle(
          //                         16,
          //                         _selectedIndex == 1
          //                             ? Colors.amber
          //                             : Colors.black,
          //                         _selectedIndex == 1
          //                             ? FontWeight.bold
          //                             : FontWeight.normal)),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     _selectedIndex = 2;
          //                   });
          //                 },
          //                 child: Text("Most Visited",
          //                     style: fontStyle(
          //                         16,
          //                         _selectedIndex == 2
          //                             ? Colors.amber
          //                             : Colors.black,
          //                         _selectedIndex == 2
          //                             ? FontWeight.bold
          //                             : FontWeight.normal)),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           SingleChildScrollView(
          //             scrollDirection: Axis.horizontal,
          //             child: Row(
          //               children: [
          //                 placesContainer(),
          //                 placesContainer(),
          //                 placesContainer(),
          //                 placesContainer(),
          //                 placesContainer(),
          //               ],
          //             ),
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Recommended",
          //                 style: fontStyle(18, Colors.black, FontWeight.bold),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   print("View All");
          //                 },
          //                 child: Text(
          //                   "View All",
          //                   style:
          //                       fontStyle(14, Colors.black, FontWeight.normal),
          //                 ),
          //               )
          //             ],
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           GridView.builder(
          //             shrinkWrap:
          //                 true, // GridView'ın yüksekliğini sınırlamak için
          //             physics:
          //                 NeverScrollableScrollPhysics(), // GridView'ı kaydırılabilir yapma
          //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 2,
          //               crossAxisSpacing: 6.0,
          //               mainAxisSpacing: 8.0,
          //             ),
          //             itemCount: 10, // 10 öğe olacak
          //             itemBuilder: (context, index) {
          //               return recommendPlacesContainer();
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        } else {
          return SimpleErrorScreen(
              errorMessage: "Veriler Getirilirken Hata oluştu");
        }
      },
    );
  }

  Row placesContainer(Place place, int index, BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceScreen(placeIndex: place.key),
              ),
            );
          },
          child: Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(place.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        // Flexible widget kullanıldı
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Taşmayı kontrol et
                              maxLines: 1, // Maksimum 1 satırda göster
                            ),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  Icons.star,
                                  color: starIndex < 4
                                      ? Colors.yellow
                                      : Colors.white,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          // Kalp butonuna tıklama işlemi
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  GestureDetector recommendPlacesContainer(Place place, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaceScreen(placeIndex: place.key), // placeIndex gönder
          ),
        );
      },
      child: Container(
        width: 100, // Genişlik ayarı
        height: 80, // Yükseklik ayarı
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image:
                NetworkImage(place.imageUrl), // Resmi arka plan olarak ayarla
            fit: BoxFit.cover, // Resmin kutuya sığacak şekilde ayarlanması
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Alt kısma hizalama
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sol taraf (İsim ve Yıldızlar)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.title, // Yer ismi
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Yazı boyutu
                          ),
                          overflow: TextOverflow.ellipsis, // Taşmayı önle
                          maxLines: 1, // Tek satır
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color:
                                  index < 4 // 4 yıldız sarı, geri kalan beyaz
                                      ? Colors.yellow
                                      : Colors.white,
                              size: 10, // Yıldız boyutu
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite,
                        color: Colors.red, size: 12), // Kalp simgesi
                    onPressed: () {
                      // Kalp butonuna basıldığında yapılacak işlemler
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Place> _getRandomPlaces(List<Place> places, int count) {
    final random = Random();
    List<Place> selectedPlaces = [];

    // Eğer total öğe sayısı seçilecek sayıdan az ise, hepsini al
    if (places.length <= count) {
      return List.from(places);
    }

    // Rastgele öğeleri seç
    while (selectedPlaces.length < count) {
      Place place = places[random.nextInt(places.length)];
      if (!selectedPlaces.contains(place)) {
        selectedPlaces.add(place);
      }
    }

    return selectedPlaces;
  }
}
