// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:route_app/screens/user/maps/maps.dart';

// class WalkingRouteMap extends StatefulWidget {
//   final int routeIndex;

//   WalkingRouteMap({required this.routeIndex}); 

//   @override
//   _WalkingRouteMapState createState() => _WalkingRouteMapState();
// }

// class _WalkingRouteMapState extends State<WalkingRouteMap> {
//   GoogleMapController? _mapController;
//   Set<Polyline> _polylines = {};
//   LatLng? _currentLocation;
//   List<LatLng> _allPolylinePoints = [];
//   bool isLoading = true;
//   double totalDistance = 0.0; 
//   int currentSegmentIndex = 0; 
//   List<Color> routeColors = [Colors.red, Colors.blue, Colors.yellow]; 
//   Color passedColor =
//       Colors.grey.withOpacity(0.5); 
  // final String googleAPIKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
// API anahtarınızı buraya ekleyin
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocationAndStartRoute();
//   }

//   Future<void> _getCurrentLocationAndStartRoute() async {
//     setState(() {
//       isLoading = true;
//     });

//     geolocator.Position position =
//         await geolocator.Geolocator.getCurrentPosition(
//             desiredAccuracy: geolocator.LocationAccuracy.high);

//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//       isLoading = false;
//     });

//     List<LatLng> _convertRoutePoints(List<int> routePoints) {
//       Map<int, Map<String, double>> placeCoordinates = {
//         1: {'lat': 37.8703256, 'lng': 32.4834427},
//         2: {'lat': 37.8713441, 'lng': 32.4835781},
//         3: {'lat': 37.8702072, 'lng': 32.4852269},
//         4: {'lat': 37.8728716, 'lng': 32.4899749},
//         5: {'lat': 37.8733208, 'lng': 32.4865003},
//         6: {'lat': 37.8733455, 'lng': 32.4903165},
//         7: {'lat': 37.8748698, 'lng': 32.4903845},
//         8: {'lat': 37.8736757, 'lng': 32.4929848},
//         9: {'lat': 37.8727992, 'lng': 32.496168},
//         10: {'lat': 37.8718669, 'lng': 32.4941504},
//         11: {'lat': 37.8716169, 'lng': 32.4958189},
//         12: {'lat': 37.871199, 'lng': 32.4968397},
//         13: {'lat': 37.8699614, 'lng': 32.4950449},
//         14: {'lat': 37.8705172, 'lng': 32.4859661},
//         15: {'lat': 37.8709511, 'lng': 32.5035289},
//       };

//       List<LatLng> latLngPoints = [];

//       for (int point in routePoints) {
//         if (placeCoordinates.containsKey(point)) {
//           double lat = placeCoordinates[point]!['lat']!;
//           double lng = placeCoordinates[point]!['lng']!;
//           latLngPoints.add(LatLng(lat, lng)); // Koordinatları LatLng'e çevir
//         }
//       }

//       return latLngPoints;
//     }

//     List<int> routePoints = findShortestRoute(widget.routeIndex);

//     List<LatLng> latLngRoutePoints = _convertRoutePoints(routePoints);

//     latLngRoutePoints.insert(
//         0, _currentLocation!); // Başlangıç ve rota noktaları
//     // List<LatLng> routePoints = [
//     //   _currentLocation!,
//     //   LatLng(37.8703256, 32.4834427), // Örnek Nokta 1
//     //   LatLng(37.8702072, 32.4852269), // Örnek Nokta 3
//     //   LatLng(37.8728716, 32.4899749), // Örnek Nokta 4
//     // ];

//     await _createWalkingRoute(latLngRoutePoints); 
//   }

//   Future<void> _createWalkingRoute(List<LatLng> latLngPoints) async {
//     for (int i = 0; i < latLngPoints.length - 1; i++) {
//       LatLng start = latLngPoints[i];
//       LatLng end = latLngPoints[i + 1];

//       String url =
//           'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=walking&key=$googleAPIKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);

//         if (data['routes'] == null || data['routes'].isEmpty) {
//           print('Boş bir route döndü!');
//           continue; // Sonraki noktaya geç
//         }

//         List<LatLng> polylinePoints =
//             _decodePolyline(data['routes'][0]['overview_polyline']['points']);

//         _allPolylinePoints.addAll(polylinePoints);

//         _addPolyline(polylinePoints, routeColors[i % routeColors.length]);
//       } else {
//         print('Directions API isteğinde hata oluştu: ${response.body}');
//       }
//     }
//   }

//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> polylineCoordinates = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;

//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;

//       LatLng position = LatLng(lat / 1E5, lng / 1E5);
//       polylineCoordinates.add(position);
//     }

//     return polylineCoordinates;
//   }

//   double _calculateDistance(
//       double lat1, double lng1, double lat2, double lng2) {
//     const R = 6371; // Dünya'nın yarıçapı km
//     double dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
//     double dLng = (lng2 - lng1) * (3.141592653589793 / 180.0);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(lat1 * (3.141592653589793 / 180.0)) *
//             cos(lat2 * (3.141592653589793 / 180.0)) *
//             sin(dLng / 2) *
//             sin(dLng / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Kilometre cinsinden mesafe
//   }

//   void _addPolyline(List<LatLng> polylinePoints, Color color) {
//     setState(() {
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId("walking_route_${currentSegmentIndex++}"),
//           visible: true,
//           points: polylinePoints,
//           color: color,
//           width: 5,
//         ),
//       );
//     });
//   }

//   void _updatePassedRoute() {
//     if (_allPolylinePoints.isNotEmpty &&
//         currentSegmentIndex < routeColors.length) {
//       setState(() {
//         for (Polyline polyline in _polylines) {
//           if (polyline.color == routeColors[currentSegmentIndex - 1]) {
//             _polylines.remove(polyline);
//             _polylines.add(polyline.copyWith(
//               colorParam: passedColor,
//             ));
//           }
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           isLoading
//               ? Center(
//                   child:
//                       CircularProgressIndicator(),
//                 )
//               : GoogleMap(
//                   onMapCreated: (controller) {
//                     _mapController = controller;
//                   },
//                   polylines: _polylines,
//                   initialCameraPosition: _currentLocation != null
//                       ? CameraPosition(
//                           target: _currentLocation!,
//                           zoom: 15,
//                         )
//                       : CameraPosition(
//                           target:
//                               LatLng(37.8703256, 32.4834427), 
//                           zoom: 15,
//                         ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

// //  Container(
// //             child: Positioned(
// //               top: 40,
// //               left: MediaQuery.of(context).size.width *
// //                   0.1, // Sol boşluk, genişliğin %10'u
// //               right: MediaQuery.of(context).size.width * 0.1,
// //               child: Column(
// //                 children: [
// //                   // Toplam km ve renk bilgisi gösterimi
// //                   Text(
// //                     'Toplam Mesafe: ${totalDistance.toStringAsFixed(2)} km',
// //                     style: TextStyle(fontSize: 18, color: Colors.black),
// //                   ),
// //                   Text(
// //                     'Rota: ${currentSegmentIndex < routeColors.length ? "Şu anki renk: ${routeColors[currentSegmentIndex].toString()}" : "Son noktaya ulaşıldı!"}',
// //                     style: TextStyle(fontSize: 16, color: Colors.black),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:route_app/screens/user/maps/maps.dart';

// class MapsScreen extends StatefulWidget {
//   final int routeIndex;

//   MapsScreen({required this.routeIndex});

//   @override
//   _MapsScreenState createState() => _MapsScreenState();
// }

// class _MapsScreenState extends State<MapsScreen> {
//   GoogleMapController? _mapController;
//   Set<Polyline> _polylines = {};
//   LatLng? _currentLocation;
//   List<LatLng> _allPolylinePoints = [];
//   bool isLoading = true;
//   double totalDistance = 0.0;
//   int currentSegmentIndex = 0;
//   List<Color> routeColors = [Colors.red, Colors.blue, Colors.yellow];
//   Color passedColor = Colors.grey.withOpacity(0.5);
  // final String googleAPIKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocationAndStartRoute();
//   }

//   Future<void> _getCurrentLocationAndStartRoute() async {
//     setState(() {
//       isLoading = true;
//     });

//     geolocator.Position position =
//         await geolocator.Geolocator.getCurrentPosition(
//             desiredAccuracy: geolocator.LocationAccuracy.high);

//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//       isLoading = false;
//     });

//     List<int> routePoints = findShortestRoute(widget.routeIndex);
//     List<LatLng> latLngRoutePoints = _convertRoutePoints(routePoints);

//     latLngRoutePoints.insert(0, _currentLocation!);

//     await _createWalkingRoute(latLngRoutePoints);
//   }

//   List<LatLng> _convertRoutePoints(List<int> routePoints) {
//     Map<int, Map<String, double>> placeCoordinates = {
//       1: {'lat': 37.8703256, 'lng': 32.4834427},
//       2: {'lat': 37.8713441, 'lng': 32.4835781},
//       3: {'lat': 37.8702072, 'lng': 32.4852269},
//       4: {'lat': 37.8728716, 'lng': 32.4899749},
//       5: {'lat': 37.8733208, 'lng': 32.4865003},
//       6: {'lat': 37.8733455, 'lng': 32.4903165},
//       7: {'lat': 37.8748698, 'lng': 32.4903845},
//       8: {'lat': 37.8736757, 'lng': 32.4929848},
//       9: {'lat': 37.8727992, 'lng': 32.496168},
//       10: {'lat': 37.8718669, 'lng': 32.4941504},
//       11: {'lat': 37.8716169, 'lng': 32.4958189},
//       12: {'lat': 37.871199, 'lng': 32.4968397},
//       13: {'lat': 37.8699614, 'lng': 32.4950449},
//       14: {'lat': 37.8705172, 'lng': 32.4859661},
//       15: {'lat': 37.8709511, 'lng': 32.5035289},
//     };

//     List<LatLng> latLngPoints = [];

//     for (int point in routePoints) {
//       if (placeCoordinates.containsKey(point)) {
//         double lat = placeCoordinates[point]!['lat']!;
//         double lng = placeCoordinates[point]!['lng']!;
//         latLngPoints.add(LatLng(lat, lng));
//       }
//     }

//     return latLngPoints;
//   }

//   Future<void> _createWalkingRoute(List<LatLng> latLngPoints) async {
//     for (int i = 0; i < latLngPoints.length - 1; i++) {
//       LatLng start = latLngPoints[i];
//       LatLng end = latLngPoints[i + 1];

//       String url =
//           'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=walking&key=$googleAPIKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);

//         if (data['routes'] == null || data['routes'].isEmpty) {
//           print('Boş bir route döndü!');
//           continue;
//         }

//         List<LatLng> polylinePoints =
//             _decodePolyline(data['routes'][0]['overview_polyline']['points']);
//         _allPolylinePoints.addAll(polylinePoints);
//         _addPolyline(polylinePoints, routeColors[i % routeColors.length]);
//       } else {
//         print('Directions API isteğinde hata oluştu: ${response.body}');
//       }
//     }
//   }

//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> polylineCoordinates = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;

//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;

//       LatLng position = LatLng(lat / 1E5, lng / 1E5);
//       polylineCoordinates.add(position);
//     }

//     return polylineCoordinates;
//   }

//   void _addPolyline(List<LatLng> polylinePoints, Color color) {
//     setState(() {
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId("walking_route_${currentSegmentIndex++}"),
//           visible: true,
//           points: polylinePoints,
//           color: color,
//           width: 5,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                   onMapCreated: (controller) {
//                     _mapController = controller;
//                   },
//                   myLocationEnabled: true, // Mavi konum işareti
//                   myLocationButtonEnabled: true, // Konum butonu
//                   polylines: _polylines,
//                   initialCameraPosition: _currentLocation != null
//                       ? CameraPosition(
//                           target: _currentLocation!,
//                           zoom: 15,
//                         )
//                       : CameraPosition(
//                           target: LatLng(37.8703256, 32.4834427),
//                           zoom: 15,
//                         ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
