import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/bloc/user/user_bloc.dart';
import 'package:accesible_route/bloc/user/user_event.dart';
import 'package:accesible_route/bloc/user/user_state.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:accesible_route/models/user_model.dart';
import 'package:accesible_route/screens/user/maps/maps_screen.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

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
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchPlace();
    _checkIfLiked();
    _checkIfRouteCompleted();
    _fetchComments();
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
          if (calendar['rating'] != null) {
            setState(() {
              hasGivenRating = true;
              userRating = calendar['rating'].toDouble();
            });
            print("Rating: ${calendar['rating']}");
          } else {
            print("Rating değeri bulunamadı");
          }
          break;
        }
      }
    }
  }

  String timeAgo(BuildContext context, String date) {
    DateTime commentDate = DateTime.parse(date);
    Duration difference = DateTime.now().difference(commentDate);

    if (difference.inMinutes < 1) {
      return S.of(context).just_now;
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${S.of(context).minutes_ago}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${S.of(context).hours_ago}";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} ${S.of(context).days_ago}";
    } else {
      return DateFormat('dd MMM yyyy').format(commentDate);
    }
  }

  Future<void> _fetchComments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();

      for (var doc in querySnapshot.docs) {
        if (doc.get('key') == widget.placeIndex) {
          List<dynamic> commentData = doc.get('comments') ?? [];

          setState(() {
            comments = commentData.map((comment) {
              return {
                'profilePhotoUrl': comment['profilePhotoUrl'],
                'username': comment['username'],
                'email': comment['email'],
                'text': comment['text'],
                'date': timeAgo(context, comment['date']),
              };
            }).toList();
          });
          break;
        }
      }
    } catch (e) {
      print("Yorumlar alınırken hata oluştu: $e");
    }
  }

  Future<void> _submitRating(double rating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !hasGivenRating) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      List<dynamic> calendars = userDoc.get('calendar') ?? [];

      for (var calendar in calendars) {
        if (calendar['routeKey'] == widget.placeIndex.toString()) {
          calendar['rating'] = rating;
          break;
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'calendar': calendars});
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();
      for (var doc in querySnapshot.docs) {
        if (doc.get('key') == widget.placeIndex) {
          int currentTotalRating = doc.get('totalRating') ?? 0.0;
          int currentRatingCount = doc.get('ratingCount') ?? 0;

          double updatedTotalRating = currentTotalRating + rating;
          int updatedRatingCount = currentRatingCount + 1;
          await doc.reference.update({
            'totalRating': updatedTotalRating,
            'ratingCount': updatedRatingCount,
          });
        }
      }

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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCommentPopup(context);
                  },
                  icon: Icon(Icons.comment, color: Colors.amber.shade800),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
              ],
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
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).comments,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (comments.isEmpty)
                          Text(
                            S.of(context).no_comments,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        else
                          Column(
                            children: comments.map((comment) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        comment['profilePhotoUrl'] ?? '',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['username'] ??
                                                S.of(context).user,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            comment['email'] ??
                                                S.of(context).email_not_found,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            comment['text'] ?? "",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            comment['date'] ??
                                                S.of(context).date_not_found,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    )
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

  void showCommentPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController commentController = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.comment, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text(
                S.of(context).write_comment,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                maxLines: 4,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: S.of(context).write_your_comment_here,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return CircularProgressIndicator();
                  } else if (state is UserSuccess) {
                    UserModel user = state.user;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        String comment = commentController.text;
                        if (comment.isNotEmpty) {
                          try {
                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('places')
                                    .get();

                            for (var doc in querySnapshot.docs) {
                              if (doc.get('key') == widget.placeIndex) {
                                await doc.reference.update({
                                  'comments': FieldValue.arrayUnion([
                                    {
                                      'profilePhotoUrl': user.profilePhoto,
                                      'username': user.username,
                                      'email': user.email,
                                      'text': comment,
                                      'date': DateTime.now().toIso8601String(),
                                    }
                                  ]),
                                });
                                break;
                              }
                            }

                            print(S.of(context).comment_added_successfully);
                            Navigator.of(context).pop();
                          } catch (e) {
                            print(S.of(context).error_adding_comment +
                                e.toString());
                          }
                        }
                      },
                      child: Text(
                        S.of(context).send,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (state is UserFailure) {
                    return Text(
                      S.of(context).user_info_not_loaded,
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
