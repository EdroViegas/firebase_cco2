import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/cards/card_case.dart';
import 'package:firebase_cco2/cards/card_category.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/screens/home.dart';

import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_cco2/ui/shared/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cases extends StatefulWidget {
  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  final ScrollController _scrollController = ScrollController();

  var total = '-';

  setTotal(val) {
    setState(() {
      total = val;
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
          stream: FirebaseFirestore.instance.collection('cases').snapshots(),
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
                      controller: _scrollController,
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

  Widget list(docs) {
    print(docs);
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: docs.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final docData = docs[index].data();

          CaseModel caseModel = CaseModel.fromData(docData);

          return CardCase(
            caseModel: caseModel,
          );
        },
      ),
    );
  }
}
