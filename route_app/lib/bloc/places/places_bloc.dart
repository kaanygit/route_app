import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/places/places_event.dart';
import 'package:route_app/bloc/places/places_state.dart';
import 'package:route_app/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PlacesBloc() : super(PlacesInitial()) {
    on<PlacesInformationGetAndSets>(_onPlacesInformationGetAndSets);
    on<PlacesInformationGets>(_onPlacesInformationGets);
  }

  Future<void> _onPlacesInformationGetAndSets(
      PlacesInformationGetAndSets event, Emitter<PlacesState> emit) async {
    try {
      emit(PlacesLoading());

      final querySnapshot = await _firestore.collection('places').get();

      List<Place> places = querySnapshot.docs.map((doc) {
        return Place(
          key: doc['key'] ?? 0,
          title: doc['title'] ?? '',
          content: doc['content'] ?? '',
          imageUrl: doc['image_url'] ?? '',
        );
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      String placesJson =
          jsonEncode(places.map((place) => place.toJson()).toList());
      await prefs.setString('places_data', placesJson);

      emit(PlacesSuccess(places));
    } catch (e) {
      emit(PlacesFailure(e.toString()));
    }
  }

  Future<void> _onPlacesInformationGets(
      PlacesInformationGets event, Emitter<PlacesState> emit) async {
    try {
      emit(PlacesLoading());

      final prefs = await SharedPreferences.getInstance();
      String? placesJson = prefs.getString('places_data');

      if (placesJson != null) {
        List<dynamic> jsonList = jsonDecode(placesJson);
        List<Place> places =
            jsonList.map((json) => Place.fromJson(json)).toList();

        emit(PlacesSuccess(places));
      } else {
        emit(PlacesFailure("Yerelde veri bulunamadı."));
      }
    } catch (e) {
      emit(PlacesFailure(e.toString()));
    }
  }
}
