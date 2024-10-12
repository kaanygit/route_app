import 'package:equatable/equatable.dart';
import 'package:route_app/models/place_model.dart';

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
