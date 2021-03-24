import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/models/creator_role.dart';
import 'package:firebase_cco2/models/receiver_role.dart';
import 'package:firebase_cco2/models/sender_role.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/firestore_service.dart';

class CaseRole {
  CreatorRole creatorRole;
  ReceiverRole receiverRole;
  SenderRole senderRole;
  CaseRole({this.creatorRole, this.receiverRole, this.senderRole});

  CaseRole.fromData(Map<String, dynamic> data)
      : creatorRole = CreatorRole.fromData(data['creator']),
        senderRole = SenderRole.fromData(data['sender']),
        receiverRole = ReceiverRole.fromData(data['receiver']) ?? null;

  Map<String, dynamic> toJson() {
    return {
      'creator': creatorRole?.toJson(),
      'receiver': receiverRole?.toJson(),
      'sender': senderRole?.toJson(),
    };
  }
}
