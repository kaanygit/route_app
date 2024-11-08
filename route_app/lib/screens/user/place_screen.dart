import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:accesible_route/screens/user/maps/maps_screen.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceScreen extends StatefulWidget {
  final int placeIndex;
  const PlaceScreen({super.key, required this.placeIndex});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  Place? _selectedPlace;
  bool isLiked = false;
  bool hasCompletedRoute = false;
  bool hasLocations = false;
  bool hasGivenRating = false;
  double userRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchPlace();
    _checkIfLiked();
    _checkIfRouteCompleted();
  }

  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      List<dynamic> likedPlaces = userDoc.get('likedPlaces') ?? [];
      setState(() {
        isLiked = likedPlaces.contains(widget.placeIndex);
      });
    }
  }

  Future<void> _checkIfRouteCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      List<dynamic> calendars = userDoc.get('calendar') ?? [];

      for (var calendar in calendars) {
        if (calendar['routeKey'] == widget.placeIndex.toString()) {
          setState(() {
            hasCompletedRoute = true;
            hasGivenRating = calendar['rating'] != null;
            userRating = calendar['rating'] != null
                ? calendar['rating'].toDouble()
                : 0.0;
          });
          break;
        }
      }
    }
  }

  Future<void> _submitRating(double rating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !hasGivenRating) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'calendars': FieldValue.arrayRemove([
          {'routeKey': widget.placeIndex.toString()}
        ])
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'calendars': FieldValue.arrayUnion([
          {'routeKey': widget.placeIndex.toString(), 'rating': rating}
        ])
      });

      setState(() {
        hasGivenRating = true;
        userRating = rating;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      if (isLiked) {
        await userDoc.update({
          'likedPlaces': FieldValue.arrayRemove([widget.placeIndex])
        });
      } else {
        await userDoc.update({
          'likedPlaces': FieldValue.arrayUnion([widget.placeIndex])
        });
      }

      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  void _fetchPlace() async {
    final placesState = context.read<PlacesBloc>().state;

    if (placesState is PlacesSuccess) {
      _selectedPlace = placesState.places
          .firstWhere((place) => place.key == widget.placeIndex,
              orElse: () => Place(
                    key: -1,
                    titleTr: "Bulunamadı",
                    titleEng: "Not Found",
                    contentTr: "Bu yer mevcut değil.",
                    contentEng: "This place does not exist.",
                    imageUrl: "default_image_url",
                    latitude: 0.0,
                    longitude: 0.0,
                  ));
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        _selectedPlace!.latitude,
        _selectedPlace!.longitude,
      );
      if (distanceInMeters < 5) {
        // 5 metre gibi bir tolerans mesafesi
        print("Aynı konumdasınız.");
        setState(() {
          hasLocations = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _currentLanguage =
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).user_place_screen_title),
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              ),
            )
          ],
        ),
      ),
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return LoadingScreen();
          } else if (state is PlacesSuccess) {
            _selectedPlace = state.places
                .firstWhere((place) => place.key == widget.placeIndex,
                    orElse: () => Place(
                          key: -1,
                          titleTr: "Bulunamadı",
                          titleEng: "Not Found",
                          contentTr: "Bu yer mevcut değil.",
                          contentEng: "This place does not exist.",
                          imageUrl: "default_image_url",
                          latitude: 0.0,
                          longitude: 0.0,
                        ));

            if (_selectedPlace == null || _selectedPlace!.key == -1) {
              return Center(
                child: Text("No place found with this index."),
              );
            }

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _selectedPlace!.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${_currentLanguage == "tr" ? _selectedPlace!.titleTr : _selectedPlace!.titleEng}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_currentLanguage == "tr" ? _selectedPlace!.contentTr : _selectedPlace!.contentEng}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (hasCompletedRoute)
                      hasGivenRating
                          ? Column(
                              children: [
                                Text(
                                  S.of(context).route_complete_title,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.green),
                                ),
                                const SizedBox(height: 8),
                                RatingBarIndicator(
                                  rating: userRating,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            )
                          : RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                _submitRating(rating);
                              },
                            ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text("An error occurred while fetching the place."),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: hasLocations
            ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasLocations ? Colors.blue : Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.of(context).route_complete_locations,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ElevatedButton(
                onPressed: () async {
                  Future<LatLng> _getCurrentLocation() async {
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    return LatLng(position.latitude, position.longitude);
                  }

                  void navigateToMapScreen(BuildContext context) async {
                    LatLng currentLocation = await _getCurrentLocation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MapsScreen(
                          routeIndex: _selectedPlace!.key,
                        ),
                      ),
                    );
                  }

                  navigateToMapScreen(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.of(context).user_place_screen_route_start_button,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
      ),
    );
  }
}
