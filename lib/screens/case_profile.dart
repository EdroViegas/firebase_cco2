import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/cards/card_case_profile.dart';
import 'package:firebase_cco2/cards/user_card.dart';
import 'package:firebase_cco2/helpers/functions.dart';
import 'package:firebase_cco2/models/case_model.dart';

import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/screens/add_case.dart';
import 'package:firebase_cco2/screens/home.dart';

import 'package:firebase_cco2/screens/sign_in.dart';
import 'package:firebase_cco2/screens/update_case.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:firebase_cco2/services/firestore_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_cco2/ui/shared/ui_helpers.dart';
import 'package:firebase_cco2/helpers/extensions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaseProfile extends StatefulWidget {
  final CaseModel caso;
  final String avatar;
  CaseProfile({Key key, this.caso, this.avatar}) : super(key: key);

  @override
  _CaseProfileState createState() => _CaseProfileState();
}

class _CaseProfileState extends State<CaseProfile> {
  TextStyle style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  bool isHighLevel = false;
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
    String time = widget.caso.activeSince?.toDate().toString();

    time =
        widget.caso.isActive ? time.formatActiveDate : time.formatPublishedDate;

    String recoverTime = widget.caso.recoveryDate?.toDate().toString();

    recoverTime = recoverTime.formatPublishedDate;
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Home()));
            }),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh_sharp),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UpdateCase(
                          caseModel: widget.caso,
                          case_id: widget.caso.id,
                        )));
              }),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('cases')
                .doc(widget.caso.id)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final doc = snapshot.data;
              final docData = doc.data();
              final id = doc.id;
              docData.putIfAbsent('id', () => id);

              CaseModel caseModel = CaseModel.fromData(docData);

              return Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CardCaseProfile(
                        caso: caseModel,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      width: screenWidth(context) * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.clock,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "Activo desde",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Text("${time}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: screenWidth(context) * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.calendarDay,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "Data recuperação",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Text("${recoverTime}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  snaCKbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: mainColor, content: Text('$message')));
  }
}
