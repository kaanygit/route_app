import 'package:accesible_route/models/place_model.dart';
import 'package:equatable/equatable.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesSuccess extends PlacesState {
  final List<Place> places;

  PlacesSuccess(this.places);
}

class PlacesFailure extends PlacesState {
  final String error;

  const PlacesFailure(this.error);

  @override
  List<Object> get props => [error];
}
