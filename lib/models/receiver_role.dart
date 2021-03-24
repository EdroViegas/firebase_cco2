import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/user_model.dart';

class ReceiverRole {
  final String receiverID;
  final Timestamp receivedAt;

  final UserModel user;

  ReceiverRole({this.receivedAt, this.user, this.receiverID});

  ReceiverRole.fromData(Map<String, dynamic> data)
      : receivedAt = data['receivedAt'],
        receiverID = data['receiverID'],
        user = UserModel.fromData(data['user'] ?? {}) ?? null;

  Map<String, dynamic> toJson() {
    return {
      'receiverID': receiverID,
      'receivedAt': receivedAt,
      'user': user?.toJson()
    };
  }
}
