import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String address;
  final String displayName;
  final String educationLevel;
  final String email;
  final bool emailVerified;
  final String fcmToken;
  final String phoneNumber;
  final String profilePhoto;
  final String uid;
  final String username;

  UserModel({
    required this.address,
    required this.displayName,
    required this.educationLevel,
    required this.email,
    required this.emailVerified,
    required this.fcmToken,
    required this.phoneNumber,
    required this.profilePhoto,
    required this.uid,
    required this.username,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      address: doc['address'] ?? '',
      displayName: doc['displayName'] ?? '',
      educationLevel: doc['educationLevel'] ?? '',
      email: doc['email'] ?? '',
      emailVerified: doc['emailVerified'] ?? false,
      fcmToken: doc['fcmToken'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? '',
      profilePhoto: doc['profilePhoto'] ?? '',
      uid: doc['uid'] ?? '',
      username: doc['username'] ?? '',
    );
  }
}
