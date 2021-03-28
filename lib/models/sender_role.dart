import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/user_model.dart';

class SenderRole {
  final String senderID;
  final Timestamp sentAt;

  final UserModel user;

  SenderRole({this.senderID, this.user, this.sentAt});

  SenderRole.fromData(Map<String, dynamic> data)
      : sentAt = data['sentAt'] ?? Timestamp(0, 0),
        senderID = data['senderID'] ?? "",
        user = UserModel.fromData(data['user'] ?? {}) ?? null;

  Map<String, dynamic> toJson() {
    return {'senderID': senderID, 'sentAt': sentAt, 'user': user?.toJson()};
  }
}
