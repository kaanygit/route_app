import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/user/user_event.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UserBloc() : super(UserInitial()) {
    on<UserInformationGets>(_onUserInformationGets);
    on<UserInformationChange>(_onUserInformationChange);
  }

  Future<void> _onUserInformationGets(
      UserInformationGets event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      bool? hasUserData = prefs.getBool('hasUserData') ?? false;

      if (!hasUserData) {
        final doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();

        if (doc.exists) {
          // Firestore'dan gelen verileri kullanıcı modeline geçiriyoruz
          UserModel user = UserModel(
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

          // Firestore'dan aldığımız verileri SharedPreferences'e kaydediyoruz
          await prefs.setString('address', user.address);
          await prefs.setString('displayName', user.displayName);
          await prefs.setString('educationLevel', user.educationLevel);
          await prefs.setString('email', user.email);
          await prefs.setBool('emailVerified', user.emailVerified);
          await prefs.setString('fcmToken', user.fcmToken);
          await prefs.setString('phoneNumber', user.phoneNumber);
          await prefs.setString('profilePhoto', user.profilePhoto);
          await prefs.setString('uid', user.uid);
          await prefs.setString('username', user.username);

          await prefs.setBool('hasUserData', true);
        } else {
          // Eğer Firestore'da kullanıcı yoksa hata döndürüyoruz
          emit(UserFailure("Kullanıcı mevcut değil"));
        }
      }
      String? address = prefs.getString('address');
      String? displayName = prefs.getString('displayName');
      String? educationLevel = prefs.getString('educationLevel');
      String? email = prefs.getString('email');
      bool? emailVerified = prefs.getBool('emailVerified');
      String? fcmToken = prefs.getString('fcmToken');
      String? phoneNumber = prefs.getString('phoneNumber');
      String? profilePhoto = prefs.getString('profilePhoto');
      String? uid = prefs.getString('uid');
      String? username = prefs.getString('username');

      UserModel user = UserModel(
        address: address ?? '',
        displayName: displayName ?? '',
        educationLevel: educationLevel ?? '',
        email: email ?? '',
        emailVerified: emailVerified ?? false,
        fcmToken: fcmToken ?? '',
        phoneNumber: phoneNumber ?? '',
        profilePhoto: profilePhoto ?? '',
        uid: uid ?? '',
        username: username ?? '',
      );

      emit(UserSuccess(user));
    } catch (e) {
      // Bir hata oluşursa hata state'i gönderiyoruz
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onUserInformationChange(
      UserInformationChange event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final String displayName = event.displayName;
      final String educationLevel = event.educationLevel;
      final String phoneNumber = event.phoneNumber;
      final String address = event.address;

      final prefs = await SharedPreferences.getInstance();

      // Firestore'dan kullanıcıyı al
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        emit(UserFailure("User not found"));
        return;
      }

      final UserModel userData = UserModel.fromDocument(userDoc);
      String currentProfilePhoto = userData.profilePhoto;
      String currentDisplayName = userData.displayName;
      String currentEducationLevel = userData.educationLevel;
      String currentPhoneNumber = userData.phoneNumber;
      String currentAddress = userData.address;

      // FirebaseAuth kullanıcı verisini al
      User? user = _auth.currentUser;
      if (user == null) {
        emit(UserFailure("User not found"));
        return;
      }

      // Profil fotoğrafı kontrolü
      String? downloadUrl;
      if (event.profilePhoto != null && event.profilePhoto!.path.isNotEmpty) {
        // Yeni profil fotoğrafı varsa, eski ile karşılaştır
        if (currentProfilePhoto != event.profilePhoto!.path) {
          // Yeni profil fotoğrafı yükle
          String fileName = 'profilePhoto/${user.uid}.jpg';
          Reference storageRef = _firebaseStorage.ref().child(fileName);
          UploadTask uploadTask = storageRef.putFile(event.profilePhoto!);
          TaskSnapshot snapshot = await uploadTask;
          downloadUrl = await snapshot.ref.getDownloadURL();
        } else {
          // Profil fotoğrafı değişmemiş, mevcut değeri kullan
          downloadUrl = currentProfilePhoto;
        }
      } else {
        // Profil fotoğrafı yoksa mevcut değeri kullan
        downloadUrl = currentProfilePhoto;
      }

      // Firestore'da kullanıcı verilerini güncelle
      final Map<String, dynamic> updates = {};
      if (displayName != currentDisplayName) {
        updates['displayName'] = displayName;
      }
      if (educationLevel != currentEducationLevel) {
        updates['educationLevel'] = educationLevel;
      }
      if (phoneNumber != currentPhoneNumber) {
        updates['phoneNumber'] = phoneNumber;
      }
      if (address != currentAddress) {
        updates['address'] = address;
      }
      if (downloadUrl != currentProfilePhoto) {
        updates['profilePhoto'] = downloadUrl;
      }

      // Eğer herhangi bir değişiklik varsa güncelle
      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }

      // Güncellenmiş kullanıcı verisini Firestore'dan al
      DocumentSnapshot updatedUserDoc =
          await _firestore.collection('users').doc(user.uid).get();
      UserModel updatedUser = UserModel.fromDocument(updatedUserDoc);
      await prefs.setString('address', updatedUser.address);
      await prefs.setString('displayName', updatedUser.displayName);
      await prefs.setString('educationLevel', updatedUser.educationLevel);
      await prefs.setString('email', updatedUser.email);
      await prefs.setBool('emailVerified', updatedUser.emailVerified);
      await prefs.setString('fcmToken', updatedUser.fcmToken);
      await prefs.setString('phoneNumber', updatedUser.phoneNumber);
      await prefs.setString('profilePhoto', updatedUser.profilePhoto);
      await prefs.setString('uid', updatedUser.uid);
      await prefs.setString('username', updatedUser.username);
      await prefs.setBool('hasUserData', false);

      emit(UserSuccess(updatedUser));
    } catch (e) {
      emit(UserFailure("Hata: ${e.toString()}"));
    }
  }
}
