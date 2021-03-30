import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/address.dart';
import 'package:firebase_cco2/models/case_role.dart';

class CaseModel {
  final String id;
  final String name;
  final String age;
  final String genre;

  final Address address;
  final String isolationPlace;
  final Timestamp activeSince;
  final bool isActive;
  final bool symptomatic;
  final String phone;
  final String altPhone;

  final CaseRole caseRole;
  final GeoPoint geolocation;

  CaseModel(
      {this.id,
      this.name,
      this.age,
      this.genre,
      this.address,
      this.isolationPlace,
      this.activeSince,
      this.altPhone,
      this.phone,
      this.caseRole,
      this.geolocation,
      this.isActive,
      this.symptomatic});

  CaseModel.fromData(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        name = data['name'] ?? "",
        age = data['age'] ?? "",
        genre = data['genre'] ?? "",
        address = Address.fromData(data['address']),
        isolationPlace = data['isolationPlace'],
        activeSince = data['activeSince'] as Timestamp,
        phone = data['phone'] ?? "",
        altPhone = data['alt_phone'] ?? "",
        caseRole = CaseRole.fromData(data['role']),
        geolocation = data['geolocation'],
        isActive = data['isActive'],
        symptomatic = data['symptomatic'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'genre': genre,
      'address': address.toJson(),
      'isActive': isActive,
      'activeSince': activeSince,
      'isolationPlace': isolationPlace,
      'phone': phone,
      'alt_phone': altPhone,
      'symptomatic': symptomatic,
      'role': caseRole.toJson()
    };
  }
}
