import 'dart:math';

import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_state.dart';
import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:accesible_route/screens/user/place_screen.dart';
import 'package:accesible_route/screens/user/view_all_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class UserHomePageScreen extends StatefulWidget {
  const UserHomePageScreen({super.key});

  @override
  State<UserHomePageScreen> createState() => _UserHomePageScreenState();
}

class _UserHomePageScreenState extends State<UserHomePageScreen> {
  late int _selectedIndex = 0;
  List<Map<String, dynamic>> allRatings = [];

  @override
  void initState() {
    super.initState();
    fetchAllRatingData();
  }

  Future<List<Map<String, dynamic>>> fetchAllRatingData() async {
    List<Map<String, dynamic>> allRatings = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();

      for (var doc in querySnapshot.docs) {
        double totalRating = doc.get('totalRating') ?? 0.0;
        int ratingCount = doc.get('ratingCount') ?? 0;
        int key = doc.get('key') ?? 0;

        allRatings.add({
          'key': key,
          'totalRating': totalRating,
          'ratingCount': ratingCount,
        });
      }
      print("total veriler :");
      print(allRatings);
    } catch (e) {
      print("Veri alınırken hata oluştu: $e");
    }

    return allRatings;
  }

  @override
  Widget build(BuildContext context) {
    String _currentLanguage =
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode;
    bool isDarkMode = ThemeUtils.isDarkMode(context);
    setState(() {
      isDarkMode = !isDarkMode;
    });
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return LoadingScreen();
        } else if (userState is UserSuccess) {
          return BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, placesState) {
              if (placesState is PlacesLoading) {
                return LoadingScreen();
              } else if (placesState is PlacesSuccess) {
                final List<Place> places = placesState.places;
                List<Place> randomPlaces = _getRandomPlaces(places, 10);

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
                                child: Text(
                                  S.of(context).user_discover_title_row_1,
                                  style: fontStyle(
                                    14,
                                    _selectedIndex == 0
                                        ? Colors.amber
                                        : !isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
                                    _selectedIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                                child: Text(
                                  S.of(context).user_discover_title_row_2,
                                  style: fontStyle(
                                    14,
                                    _selectedIndex == 1
                                        ? Colors.amber
                                        : !isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
                                    _selectedIndex == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                  });
                                },
                                child: Text(
                                  S.of(context).user_discover_title_row_3,
                                  style: fontStyle(
                                    14,
                                    _selectedIndex == 2
                                        ? Colors.amber
                                        : !isDarkMode
                                            ? Colors.grey
                                            : Colors.black,
                                    _selectedIndex == 2
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                placesContainer(places[1], 1, context,
                                    isDarkMode, _currentLanguage),
                                placesContainer(places[3], 3, context,
                                    isDarkMode, _currentLanguage),
                                placesContainer(places[5], 5, context,
                                    isDarkMode, _currentLanguage),
                                placesContainer(places[7], 7, context,
                                    isDarkMode, _currentLanguage),
                                placesContainer(places[9], 9, context,
                                    isDarkMode, _currentLanguage),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).user_discover_recommend_title,
                                style: fontStyle(
                                    18,
                                    isDarkMode ? Colors.black : Colors.white,
                                    FontWeight.bold),
                              ),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewAllScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    S.of(context).user_discover_view_all_title,
                                    style: fontStyle(
                                        14,
                                        isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 6.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: randomPlaces.length,
                            itemBuilder: (context, index) {
                              bool isDarkMode = ThemeUtils.isDarkMode(context);
                              return recommendPlacesContainer(
                                  randomPlaces[index],
                                  context,
                                  isDarkMode,
                                  _currentLanguage);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return LoadingScreen();
              }
            },
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }

  Row placesContainer(Place place, int index, BuildContext context,
      bool isDarkMode, String _currentLanguage) {
    print(allRatings);
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
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                      child: buildDistanceText(
                          targetLat: place.latitude,
                          targetLng: place.longitude)),
                  top: 0,
                  right: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentLanguage == "tr"
                                      ? place.titleTr
                                      : place.titleEng,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                          LikeButtonWidget(
                            placeIndex: place.key,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  GestureDetector recommendPlacesContainer(Place place, BuildContext context,
      bool isDarkMode, String _currentLanguage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceScreen(placeIndex: place.key),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(place.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                  child: buildDistanceText(
                      targetLat: place.latitude, targetLng: place.longitude)),
              top: 0,
              right: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentLanguage == "tr"
                                  ? place.titleTr
                                  : place.titleEng,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  color:
                                      index < 4 ? Colors.yellow : Colors.white,
                                  size: 10,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      LikeButtonWidget(
                        placeIndex: place.key,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Place> _getRandomPlaces(List<Place> places, int count) {
    final random = Random();
    List<Place> selectedPlaces = [];

    if (places.length <= count) {
      return List.from(places);
    }

    while (selectedPlaces.length < count) {
      Place place = places[random.nextInt(places.length)];
      if (!selectedPlaces.contains(place)) {
        selectedPlaces.add(place);
      }
    }

    return selectedPlaces;
  }

  Widget buildDistanceText(
      {required double targetLat, required double targetLng}) {
    Future<String> _calculateDistance() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          targetLat,
          targetLng,
        );

        double distanceInKm = distanceInMeters / 1000;

        return '${distanceInKm.toStringAsFixed(2)}KM';
      } catch (e) {
        return 'Mesafe hesaplanamadı';
      }
    }

    return FutureBuilder<String>(
      future: _calculateDistance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(S.of(context).app_calculate);
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else {
          return Text(snapshot.data ?? 'Mesafe hesaplanamadı');
        }
      },
    );
  }
}

class LikeButtonWidget extends StatefulWidget {
  final int placeIndex;

  LikeButtonWidget({required this.placeIndex});

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool _isLiked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLikedStatus();
  }

  Future<void> _fetchLikedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      List<dynamic> likedPlaces = userDoc.get('likedPlaces') ?? [];
      setState(() {
        _isLiked = likedPlaces.contains(widget.placeIndex);
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      if (_isLiked) {
        await userDoc.update({
          'likedPlaces': FieldValue.arrayRemove([widget.placeIndex])
        });
      } else {
        await userDoc.update({
          'likedPlaces': FieldValue.arrayUnion([widget.placeIndex])
        });
      }

      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: _isLiked ? Colors.red : Colors.grey,
        size: 24,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
