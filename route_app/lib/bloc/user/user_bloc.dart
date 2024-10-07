import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/user/user_event.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UserBloc() : super(UserInitial()) {
    on<UserInformationGets>(_onUserInformationGets);
  }

  Future<void> _onUserInformationGets(
      UserInformationGets event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (doc.exists) {
        UserModel user = UserModel.fromDocument(doc);
        emit(UserSuccess(user));
      } else {
        emit(UserFailure("User does not exist"));
      }
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}
