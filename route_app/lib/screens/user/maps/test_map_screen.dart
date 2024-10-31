// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:route_app/widgets/buttons.dart';

// class TestMapScreen extends StatefulWidget {
//   @override
//   _TestMapScreenState createState() => _TestMapScreenState();
// }

// class _TestMapScreenState extends State<TestMapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLocation;
//   Set<Marker> _markers = {};
//   List<Map<String, dynamic>> _places = [];
//   bool _isLoading = true;
//   final Dio dio = Dio();
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//     });

//     _fetchNearbyPlaces(); 
//   }

//   Future<void> _fetchNearbyPlaces() async {
//     final url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=1500&type=wc&key=';

//     try {
//       final response = await dio.get(url);

//       if (response.statusCode == 200) {
//         final data = response.data;
//         final List places = data['results'];

//         print(data);
//         for (var place in places) {
//           print('Mekan: ${place['name']}');
//           print(
//               'Konum: ${place['geometry']['location']['lat']}, ${place['geometry']['location']['lng']}');
//         }

//         _addMarkers(places);
//       } else {
//         print('API isteği başarısız: ${response.data}');
//       }
//     } catch (e) {
//       print('Dio hatası: $e');
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _addMarkers(List places) {
//     Set<Marker> markers = {};
//     List<Map<String, dynamic>> placesWithDistance = [];

//     for (var place in places) {
//       final placeName = place['name'];
//       final lat = place['geometry']['location']['lat'];
//       final lng = place['geometry']['location']['lng'];

//       final distance = Geolocator.distanceBetween(
//         _currentLocation!.latitude,
//         _currentLocation!.longitude,
//         lat,
//         lng,
//       );

//       placesWithDistance.add({
//         'name': placeName,
//         'distance': distance,
//       });

//       markers.add(
//         Marker(
//           markerId: MarkerId(placeName),
//           position: LatLng(lat, lng),
//           infoWindow: InfoWindow(title: placeName),
//         ),
//       );
//     }

//     setState(() {
//       _markers = markers;
//       _places = placesWithDistance;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                   onMapCreated: (controller) {
//                     _mapController = controller;
//                   },
//                   markers: _markers,
//                   initialCameraPosition: CameraPosition(
//                     target: _currentLocation ?? LatLng(37.7937, -122.3965),
//                     zoom: 15,
//                   ),
//                 ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.2,
//             minChildSize: 0.1,
//             maxChildSize: 0.6,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         controller: scrollController,
//                         itemCount: _places.length,
//                         itemBuilder: (context, index) {
//                           final place = _places[index];
//                           return ListTile(
//                             title: Text(place['name']),
//                             trailing: Icon(
//                               Icons.location_on,
//                               color: Colors.blue, // Konum ikonu
//                             ),
//                             subtitle: Text(
//                               '${place['distance'].toStringAsFixed(2)} m uzaklıkta',
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.all(8.0), // Buton için biraz boşluk
//                       child: MyButton(
//                         text: "Rotayı Bitir",
//                         buttonColor: Colors.blue,
//                         buttonTextColor: Colors.white,
//                         buttonTextSize: 18,
//                         buttonTextWeight: FontWeight.normal,
//                         onPressed: () {
//                           print("bitti");
//                         },
//                         buttonWidth: ButtonWidth.xLarge, // Buton genişliği
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ), // Buton ile kenar arasında biraz boşluk
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
