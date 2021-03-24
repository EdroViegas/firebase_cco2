import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/firestore_service.dart';

class CreatorRole {
  final String creatorID;
  final Timestamp createdAt;

  final UserModel user;

  CreatorRole({this.createdAt, this.user, this.creatorID});

  CreatorRole.fromData(Map<String, dynamic> data)
      : createdAt = data['createdAt'],
        creatorID = data['creatorID'],
        user = UserModel.fromData(data['user'] ?? {}) ?? null;

  Map<String, dynamic> toJson() {
    return {
      'creatorID': creatorID,
      'createdAt': createdAt,
      'user': user?.toJson()
    };
  }
}
