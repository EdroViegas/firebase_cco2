import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/models/case_role.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_cco2/helpers/extensions.dart';

class Cases extends StatefulWidget {
  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [Text("Stats Place")],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('cases')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final docData = snapshot.data.docs[index].data();
                          CaseRole roles = CaseRole.fromData(docData['role']);

                          CaseModel caseModel =
                              CaseModel.fromData(docData, roles);

                          //print("ALL ROLES ARE :${roles.toJson()}");

                          String healthStatus = caseModel.symptomatic
                              ? "Sintomático"
                              : "Assintomático";

                          Color healthStatusColor =
                              caseModel.symptomatic ? secondColor : mainColor;

                          String activeStatus =
                              caseModel.isActive ? "Activo" : "Recuperado";

                          Color activeStatusColor =
                              caseModel.isActive ? mainColor : secondColor;

                          String time =
                              caseModel.activeSince.toDate().toString();

                          time = caseModel.isActive
                              ? time.formatActiveDate
                              : time.formatPublishedDate;

                          print(
                              "CASE MODEL JSON INFO IS : ${caseModel.toJson()}");

                          return Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(),
                                          Chip(
                                            label: Text(
                                              "$activeStatus",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            backgroundColor: activeStatusColor
                                                .withOpacity(0.2),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15, top: 8),
                                            child: Container(
                                              width: 95,
                                              height: 95,
                                              decoration: BoxDecoration(
                                                //color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Icon(Icons.person_outline,
                                                  size: 95,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${caseModel.name}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      "${caseModel.address.city}, ${caseModel.address.county} ,${caseModel.address.street} "),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      "${caseModel.address.reference}"),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 18,
                                                        color: mainColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          "${caseModel.isolationPlace}"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.phone,
                                                        size: 18,
                                                        color: mainColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          "${caseModel.phone} | ${caseModel.altPhone}"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_outlined,
                                            size: 20,
                                            color: mainColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("$time"),
                                        ],
                                      ),
                                      caseModel.isActive
                                          ? Chip(
                                              label: Text(
                                                "$healthStatus",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor:
                                                  healthStatusColor,
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
