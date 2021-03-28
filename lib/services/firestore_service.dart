import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/models/user_model.dart';

import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _casesCollectionReference =
      FirebaseFirestore.instance.collection('cases');

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createCase(CaseModel caso) async {
    try {
      var data = await _casesCollectionReference.doc().set(caso.toJson());
      return data;
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      print("DATA IS > ${userData.data()}");
      return UserModel.fromData(userData.data());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
        return null;
      }

      return e.toString();
    }
  }
}
