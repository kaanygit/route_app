import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_app/bloc/places/places_bloc.dart';
import 'package:route_app/bloc/places/places_state.dart';
import 'package:route_app/models/place_model.dart';
import 'package:route_app/screens/user/maps/maps_screen.dart';
import 'package:route_app/widgets/loading.dart';

class PlaceScreen extends StatefulWidget {
  final int placeIndex;
  const PlaceScreen({super.key, required this.placeIndex});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  Place? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _fetchPlace();
  }

  void _fetchPlace() {
    final placesState = context.read<PlacesBloc>().state;

    if (placesState is PlacesSuccess) {
      _selectedPlace = placesState.places.firstWhere(
          (place) => place.key == widget.placeIndex,
          orElse: () => Place(
              key: -1,
              title: "Not Found",
              content: "This place does not exist.",
              imageUrl: "default_image_url"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Details"),
      ),
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return LoadingScreen();
          } else if (state is PlacesSuccess) {
            _selectedPlace = state.places.firstWhere(
                (place) => place.key == widget.placeIndex,
                orElse: () => Place(
                    key: -1,
                    title: "Not Found",
                    content: "This place does not exist.",
                    imageUrl: "default_image_url"));

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
                      _selectedPlace!.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedPlace!.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
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
        child: ElevatedButton(
          onPressed: () async {
            Future<LatLng> _getCurrentLocation() async {
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              return LatLng(position.latitude, position.longitude);
            }

            void navigateToMapScreen(BuildContext context) async {
              LatLng currentLocation = await _getCurrentLocation();
              print(currentLocation);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MapScreen(initialLocation: currentLocation),
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
            "Rotaya Başla",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
