import 'package:equatable/equatable.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();
  @override
  List<Object?> get props => [];
}

class PlacesInformationGets extends PlacesEvent {}

class PlacesInformationGetAndSets extends PlacesEvent {}
