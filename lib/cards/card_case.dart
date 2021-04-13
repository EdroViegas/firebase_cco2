import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/helpers/dialogues.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/screens/case_profile.dart';
import 'package:firebase_cco2/screens/update_case.dart';
import 'package:firebase_cco2/services/firestore_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_cco2/helpers/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardCase extends StatelessWidget {
  final CaseModel caseModel;
  CardCase({this.caseModel});

  FirestoreService _firestoreService = FirestoreService();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String healthStatus =
        caseModel.symptomatic ? "Sintomático" : "Assintomático";

    Color healthStatusColor = caseModel.symptomatic ? mainColor : secondColor;

    String activeStatus = caseModel.isActive ? "Activo" : "Recuperado";

    Color activeStatusColor = caseModel.isActive ? mainColor : secondColor;

    String time = caseModel.activeSince?.toDate().toString();

    time =
        caseModel.isActive ? time.formatActiveDate : time.formatPublishedDate;

    String imgGenre = caseModel.genre == "Masculino"
        ? "urban-user-1.png"
        : "urban-user-2.png";

    bool isFollower = _auth.currentUser.uid == caseModel.followedby.id;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => CaseProfile(
                  caso: caseModel,
                  avatar: imgGenre,
                )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0,
                        color: Color(0xfff5f5f5).withOpacity(0.5),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.venusMars,
                                    size: 18,
                                    color: mainColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${caseModel.genre}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.userClock,
                                    size: 18,
                                    color: mainColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${caseModel.age} ${caseModel.ageType}",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: activeStatusColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          //Permite apenas quem esta  a seguir o caso modificar
                          if (isFollower) {
                            _showMyDialogActive(
                                context: context, status: activeStatus);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: mainColor,
                                content:
                                    Text('Não é responsável por esse caso!')));
                          }
                        },
                        child: Text(
                          "$activeStatus",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15, top: 8),
                        child: Container(
                          width: 95,
                          height: 95,
                          decoration: BoxDecoration(
                            //color: Colors.grey[200],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/$imgGenre")),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${caseModel.name}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "${caseModel.address.city}, ${caseModel.address.county} ,${caseModel.address.street} "),
                              SizedBox(
                                height: 5,
                              ),
                              Text("${caseModel.address.reference}"),
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
                                  Text("${caseModel.isolationPlace}"),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: healthStatusColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            if (isFollower) {
                              _showMyDialogSymptom(
                                  context: context, status: healthStatus);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: mainColor,
                                      content: Text(
                                          'Não é responsável por esse caso!')));
                            }
                          },
                          child: Text(
                            "$healthStatus",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ))
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialogActive({context, state, status}) async {
    status = (status == "Activo") ? "Recuperado" : "Activo";

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Situação do caso'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Tem a certeza que deseja mudar para $status ? '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                _firestoreService
                    .changeCaseState(
                      id: caseModel.id,
                      state: 'isActive',
                      value: !caseModel.isActive,
                    )
                    .then((value) {})
                    .onError((error, stackTrace) {
                  print("ERROR WHILE UPDATING CASE $error");
                  registerErrorDialogue(
                    hasError: false,
                    isProcessing: false,
                    isWarning: false,
                    message: 'Não foi possível mudar para $status!',
                    context: context,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogSymptom({context, state, status}) async {
    status = (status == "Sintomático") ? "Assintomático" : "Sintomático";
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sintoma'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Tem a certeza que deseja mudar para $status ? '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                _firestoreService
                    .changeCaseState(
                        id: caseModel.id,
                        state: 'symptomatic',
                        value: !caseModel.symptomatic)
                    .then((value) {})
                    .onError((error, stackTrace) {
                  print("ERROR WHILE UPDATING CASE $error");
                  registerErrorDialogue(
                    hasError: false,
                    isProcessing: false,
                    isWarning: false,
                    message: 'Não foi possível mudar para $status!',
                    context: context,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
