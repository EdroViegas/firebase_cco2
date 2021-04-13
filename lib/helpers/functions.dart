import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/firestore_service.dart';

final FirestoreService _firestoreService = FirestoreService();
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

User _currentUser;

getCurrentUser() {
  _currentUser = _firebaseAuth.currentUser;
}

Future<bool> hasHighLevel() async {
  List<String> roles = ['CENTRAL', 'MUNICIPAL'];
  getCurrentUser();
  UserModel user = await _firestoreService.getUser(_currentUser.uid);

  return roles.contains(user.userRole);
}
