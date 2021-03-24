import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/services/shared_prefs_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_cco2/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  final FirestoreService _firestoreService = FirestoreService();
  SharedPref sharedPref = SharedPref();

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail(
      {@required String fullName,
      @required String address,
      @required String email,
      @required String phone,
      @required String altPhone,
      @required String userRole,
      @required String password}) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      //ACRESCENTAR MAIS CAMPOS
      _currentUser = UserModel(
        id: authResult.user.uid,
        fullName: fullName,
        address: address,
        email: email,
        phone: phone,
        altPhone: altPhone,
        userRole: userRole,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      sharedPref.save('user', _currentUser.toJson());
    }
  }
}
