import 'package:accesible_route/bloc/auth/auth_event.dart';
import 'package:accesible_route/bloc/auth/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  AuthBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _firebaseStorage = FirebaseStorage.instance,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithEmailAndPasswordEvent>(_onAuthSignInRequested);
    on<SignUpEvent>(_onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = _auth.currentUser;
    if (user != null) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
      SignInWithEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthSignUpRequested(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await _firestore.collection('users').doc(user.uid).set({
          'displayName': event.username,
          'username': event.username,
          'uid': userCredential.user?.uid,
          'profilePhoto': "",
          'phoneNumber': '',
          'educationLevel': '',
          'address': '',
          "fcmToken": "",
          "likedPlaces": [],
          "isAccountFrozen": false,
          "isAdmin": false,
          "calendar": [],
          "calendars": [],
          'email': event.email,
          "emailVerified": false,
          'updatedUser': DateTime.now(),
          'createdAt': DateTime.now(),
        });
      }
      emit(Authenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
      AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': googleUser.displayName ?? "",
            'username': googleUser.displayName ?? "",
            'uid': user.uid,
            'profilePhoto': googleUser.photoUrl ?? "",
            'phoneNumber': user.phoneNumber ?? '',
            'educationLevel': '',
            'address': '',
            "fcmToken": "",
            "likedPlaces": [],
            "isAccountFrozen": false,
            "isAdmin": false,
            "calendar": [],
            "calendars": [],
            'email': googleUser.email,
            "emailVerified": user.emailVerified,
            'updatedUser': DateTime.now(),
            'createdAt': DateTime.now(),
          });

          emit(Authenticated());
        } else {
          emit(AuthFailure("Kullanıcı bilgileri alınamadı."));
        }
      } else {
        emit(AuthFailure("Google ile oturum açma iptal edildi."));
      }
    } catch (e) {
      emit(AuthFailure("Google ile oturum açarken hata: ${e.toString()}"));
    }
  }

  Future<void> _onAuthSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("hasUserData", false);
      await _auth.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure("Çıkış yaparken hata oluştu"));
    }
  }
}
