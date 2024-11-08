import 'dart:async';
import 'dart:math';

import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/user/maps/maps.dart';
import 'package:accesible_route/screens/user/maps/route_complete_screen.dart';
import 'package:accesible_route/widgets/buttons.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapsScreen extends StatefulWidget {
  final int routeIndex;

  MapsScreen({required this.routeIndex});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  FlutterTts flutterTts = FlutterTts();
  bool isVoiceEnabled = true;
  LatLng? _currentLocation;
  List<LatLng> _allPolylinePoints = [];
  bool isLoading = true;
  final Dio dio = Dio();
  List<Map<String, dynamic>> _places = [];
  Set<Marker> _markers = {};
  double totalDistance = 0.0;
  int currentSegmentIndex = 0;
  List<Color> routeColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.black
  ];
  Color passedColor = Colors.grey.withOpacity(0.5);
  final String googleAPIKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  List<Map<String, dynamic>> _stepInstructions = [];
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndStartRoute();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocationAndStartRoute() async {
    setState(() {
      isLoading = true;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      isLoading = false;
    });

    List<int> routePoints = findShortestRoute(widget.routeIndex);
    List<LatLng> latLngRoutePoints = _convertRoutePoints(routePoints);

    latLngRoutePoints.insert(0, _currentLocation!);
    _fetchNearbyPlaces();
    _startListeningToLocationChanges();
    await _createWalkingRoute(latLngRoutePoints);
  }

  List<LatLng> _convertRoutePoints(List<int> routePoints) {
    Map<int, Map<String, double>> placeCoordinates = {
      1: {'lat': 37.8703256, 'lng': 32.4834427},
      2: {'lat': 37.8713441, 'lng': 32.4835781},
      3: {'lat': 37.8702072, 'lng': 32.4852269},
      4: {'lat': 37.8728716, 'lng': 32.4899749},
      5: {'lat': 37.8733208, 'lng': 32.4865003},
      6: {'lat': 37.8733455, 'lng': 32.4903165},
      7: {'lat': 37.8748698, 'lng': 32.4903845},
      8: {'lat': 37.8736757, 'lng': 32.4929848},
      9: {'lat': 37.8727992, 'lng': 32.496168},
      10: {'lat': 37.8718669, 'lng': 32.4941504},
      11: {'lat': 37.8716169, 'lng': 32.4958189},
      12: {'lat': 37.871199, 'lng': 32.4968397},
      13: {'lat': 37.8699614, 'lng': 32.4950449},
      14: {'lat': 37.8705172, 'lng': 32.4859661},
      15: {'lat': 37.8709511, 'lng': 32.5035289},
      16: {'lat': 37.872438, 'lng': 32.494374},
      17: {'lat': 37.870768, 'lng': 32.492141},
      18: {'lat': 37.870913, 'lng': 32.490837},
      19: {'lat': 37.870913, 'lng': 32.490837},
      20: {'lat': 37.872403, 'lng': 32.494151},
      21: {'lat': 37.870925, 'lng': 32.492724},
      22: {'lat': 37.870937, 'lng': 32.490715},
      23: {'lat': 37.870937, 'lng': 32.490715},
      24: {'lat': 37.870937, 'lng': 32.490715},
      25: {'lat': 37.870937, 'lng': 32.490715},
      26: {'lat': 37.872476, 'lng': 32.494136},
      27: {'lat': 37.872476, 'lng': 32.494136},
      28: {'lat': 37.872708, 'lng': 32.494243},
    };

    List<LatLng> latLngPoints = [];

    for (int point in routePoints) {
      if (placeCoordinates.containsKey(point)) {
        double lat = placeCoordinates[point]!['lat']!;
        double lng = placeCoordinates[point]!['lng']!;
        latLngPoints.add(LatLng(lat, lng));
      }
    }

    return latLngPoints;
  }

  Future<void> _createWalkingRoute(List<LatLng> latLngPoints) async {
    for (int i = 0; i < latLngPoints.length - 1; i++) {
      LatLng start = latLngPoints[i];
      LatLng end = latLngPoints[i + 1];

      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=walking&key=$googleAPIKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data['routes'] == null || data['routes'].isEmpty) {
          print('Boş bir route döndü!');
          continue;
        }

        List<LatLng> polylinePoints =
            _decodePolyline(data['routes'][0]['overview_polyline']['points']);
        _allPolylinePoints.addAll(polylinePoints);
        _addPolyline(polylinePoints, routeColors[i % routeColors.length]);
        List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];

        for (var step in steps) {
          LatLng stepEndLocation =
              LatLng(step['end_location']['lat'], step['end_location']['lng']);
          _stepInstructions.add({'endLocation': stepEndLocation});
        }
      } else {
        print('Directions API isteğinde hata oluştu: ${response.body}');
      }
    }
  }

  void _startListeningToLocationChanges() {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _checkProximityForSteps();
    });
  }

  void _checkProximityForSteps() {
    if (_currentLocation == null) return;

    for (var step in _stepInstructions) {
      LatLng stepEndLocation = step['endLocation'];

      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        stepEndLocation.latitude,
        stepEndLocation.longitude,
      );

      if (distance < 30 && isVoiceEnabled) {
        String direction = _getDirectionRelativeToUser(stepEndLocation);
        _speak(direction);
        break;
      }
    }
  }

  String _getDirectionRelativeToUser(LatLng stepEndLocation) {
    double userLat = _currentLocation!.latitude;
    double userLng = _currentLocation!.longitude;
    double stepLat = stepEndLocation.latitude;
    double stepLng = stepEndLocation.longitude;

    double angle = atan2(stepLng - userLng, stepLat - userLat) * (180 / pi);

    if (angle < 0) {
      angle += 360;
    }

    if (angle >= 45 && angle < 135) {
      return "Önünde";
    } else if (angle >= 135 && angle < 225) {
      return "Solunda";
    } else if (angle >= 225 && angle < 315) {
      return "Arkanda";
    } else {
      return "Sağında";
    }
  }

  Future<void> _speak(String message) async {
    if (isVoiceEnabled) {
      await flutterTts.setLanguage("tr-TR");
      await flutterTts.speak(message);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng position = LatLng(lat / 1E5, lng / 1E5);
      polylineCoordinates.add(position);
    }

    return polylineCoordinates;
  }

  void _addPolyline(List<LatLng> polylinePoints, Color color) {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId("walking_route_${currentSegmentIndex++}"),
          visible: true,
          points: polylinePoints,
          color: color,
          width: 5,
        ),
      );
    });
  }

  Future<void> _fetchNearbyPlaces() async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=1500&type=wc&key=$googleAPIKey';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final List places = data['results'];

        for (var place in places) {
          print('Mekan: ${place['name']}');
          print(
              'Konum: ${place['geometry']['location']['lat']}, ${place['geometry']['location']['lng']}');
        }

        _addMarkers(places);
      } else {
        print('API isteği başarısız: ${response.data}');
      }
    } catch (e) {
      print('Dio hatası: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void _addMarkers(List places) {
    Set<Marker> markers = {};
    List<Map<String, dynamic>> placesWithDistance = [];

    for (var place in places) {
      final placeName = place['name'];
      final lat = place['geometry']['location']['lat'];
      final lng = place['geometry']['location']['lng'];

      final distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        lat,
        lng,
      );

      placesWithDistance.add({
        'name': placeName,
        'distance': distance,
      });

      markers.add(
        Marker(
          markerId: MarkerId(placeName),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: placeName),
        ),
      );
    }

    setState(() {
      _markers = markers;
      _places = placesWithDistance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  polylines: _polylines,
                  markers: _markers,
                  initialCameraPosition: _currentLocation != null
                      ? CameraPosition(
                          target: _currentLocation!,
                          zoom: 15,
                        )
                      : CameraPosition(
                          target: LatLng(37.8703256, 32.4834427),
                          zoom: 15,
                        ),
                ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.15,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _places.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < _places.length) {
                      final place = _places[index];
                      return ListTile(
                        title: Text(place['name']),
                        trailing: Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                        subtitle: Text(
                            '${(place['distance'] / 1000).toStringAsFixed(2)} km uzaklıkta'),
                      );
                    } else if (index == _places.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                text: isVoiceEnabled
                                    ? "🔊 ${S.of(context).maps_screen_open_volume}" // Ses açıkken hoparlör simgesi
                                    : "🔈 ${S.of(context).maps_screen_closed_volume}", // Ses kapalıyken hoparlör simgesi
                                buttonColor: isVoiceEnabled
                                    ? Colors.blue
                                    : Colors.red, // Ses durumuna göre renk
                                buttonTextColor: Colors.white,
                                buttonTextSize: 18,
                                buttonTextWeight: FontWeight.normal,
                                borderRadius: BorderRadius.circular(16),
                                onPressed: () {
                                  setState(() {
                                    isVoiceEnabled = !isVoiceEnabled;
                                  });
                                },
                                buttonWidth: ButtonWidth.xLarge,
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyButton(
                                text: S
                                    .of(context)
                                    .maps_screen_end_route_button_submit2,
                                buttonColor: Colors.blue,
                                buttonTextColor: Colors.white,
                                buttonTextSize: 18,
                                buttonTextWeight: FontWeight.normal,
                                borderRadius: BorderRadius.circular(16),
                                onPressed: () =>
                                    _showFinishRouteBottomSheet(context),
                                buttonWidth: ButtonWidth.xLarge),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                      // Son metin widget'ı
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFinishRouteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).maps_screen_end_route_button_submit,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).app_no,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            final FirebaseAuth _auth = FirebaseAuth.instance;

                            return RouteCompleteScreen(
                              routeKey: widget.routeIndex,
                              userId: _auth.currentUser!.uid,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).app_yes,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
