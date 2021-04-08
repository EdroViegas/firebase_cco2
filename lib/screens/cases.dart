import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/cards/card_case.dart';
import 'package:firebase_cco2/cards/card_category.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/screens/home.dart';
import 'package:firebase_cco2/services/firestore_service.dart';
import 'package:firebase_cco2/services/shared_prefs_service.dart';

import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_cco2/ui/shared/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cases extends StatefulWidget {
  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _currentUser;
  var snapshot;
  var total = '-';
  bool isHighLevel = false;

  setTotal(val) {
    setState(() {
      total = val;
    });
  }

  getCurrentUser() {
    _currentUser = _firebaseAuth.currentUser;
  }

  Future<bool> hasHighLevel() async {
    List<String> roles = ['CENTRAL', 'MUNICIPAL'];
    getCurrentUser();
    UserModel user = await _firestoreService.getUser(_currentUser.uid);

    return roles.contains(user.userRole);
  }

  @override
  void initState() {
    super.initState();
    hasHighLevel().then((value) {
      isHighLevel = value;
    }).onError((error, stackTrace) {
      print("Error attempting to get level ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Home()));
            }),
      ),
      body: Center(
        child: StreamBuilder(
          stream: !isHighLevel
              ? FirebaseFirestore.instance
                  .collection('cases')
                  .where("followedby.id", isEqualTo: _currentUser.uid)
                  .snapshots()
              : FirebaseFirestore.instance.collection('cases').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            int length = snapshot.data.docs.length;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: screenWidth(context),
                  child: CardCaseCategory(
                      hasStatistic: true,
                      title: "TOTAL DE CASOS",
                      value: length,
                      image: "assets/images/pale-coronavirus.png",
                      icon: FontAwesomeIcons.viruses,
                      color: mainColor),
                ),
                Expanded(
                  child: Container(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: ListView.builder(
                            itemCount: length,
                            itemBuilder: (BuildContext context, int index) {
                              final doc = snapshot.data.docs[index];
                              final docData = doc.data();
                              final id = doc.id;
                              docData.putIfAbsent('id', () => id);

                              CaseModel caseModel = CaseModel.fromData(docData);

                              //print("ALL ROLES ARE :${roles.toJson()}");

                              return CardCase(
                                caseModel: caseModel,
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
