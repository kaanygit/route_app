import 'package:accesible_route/bloc/places/places_event.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        print(doc['title_tr']);
        print("hello ${doc['title_tr']}");
        print("GELİRKEN SIKINTILAR VAR");
        return Place(
          key: doc['key'] ?? 0,
          titleTr: doc['title_tr'] ?? '',
          titleEng: doc['title_eng'] ?? '',
          contentTr: doc['content_tr'] ?? '',
          contentEng: doc['content_eng'] ?? '',
          imageUrl: doc['image_url'] ?? '',
          latitude: doc['latitude']?.toDouble() ?? 0.0,
          longitude: doc['longitude']?.toDouble() ?? 0.0,
        );
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      String placesJson =
          jsonEncode(places.map((place) => place.toJson()).toList());
      await prefs.setString('places_data', placesJson);
      var jsonData = jsonDecode(placesJson);
      jsonData.forEach((place) {
        var key = place['key'];
        var latitude = place['latitude'];
        var longitude = place['longitude'];

        print('Key: $key, Latitude: $latitude, Longitude: $longitude');
      });
      print(jsonData);

      emit(PlacesSuccess(places));
    } catch (e) {
      print("hata şurda  $e");
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

        Future<String?> getPlacesDataFromSharedPrefs() async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String? placesJson = prefs.getString('places_data');
          return placesJson;
        }

        emit(PlacesSuccess(places));
      } else {
        emit(PlacesFailure("Yerelde veri bulunamadı."));
      }
    } catch (e) {
      emit(PlacesFailure(e.toString()));
    }
  }
}
