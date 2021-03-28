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
    sharedPref.remove('user');
  }

  isVerifiedUser() {
    return _firebaseAuth.currentUser.emailVerified;
  }

  Future reloadUser() async {
    await _firebaseAuth.currentUser.reload();
  }

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    String errorMessage;
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      if (!isVerifiedUser()) authResult.user.sendEmailVerification();
      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }

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
      bool isVerified = isVerifiedUser();

      _currentUser = await _firestoreService.getUser(user.uid);
      Map<String, dynamic> userData = _currentUser.toJson();

      userData.putIfAbsent('verified', () => isVerified ? '1' : '0');

      sharedPref.save('user', userData);
    }
  }
}
