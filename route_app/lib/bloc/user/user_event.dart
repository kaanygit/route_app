import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class UserInformationGets extends UserEvent {}

class UserInformationGetAndSets extends UserEvent {}

class UserInformationChange extends UserEvent {
  final String displayName;
  final String educationLevel;
  final String phoneNumber;
  final File? profilePhoto;
  final String address;

  UserInformationChange({
    required this.address,
    required this.displayName,
    required this.educationLevel,
    required this.phoneNumber,
    this.profilePhoto,
  });

  @override
  List<Object?> get props =>
      [address, displayName, educationLevel, phoneNumber, profilePhoto];
}
