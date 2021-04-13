import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/helpers/dialogues.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/services/firestore_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_cco2/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_cco2/helpers/extensions.dart';

class CardCaseProfile extends StatefulWidget {
  final CaseModel caso;

  CardCaseProfile({this.caso});
  @override
  _CardCaseProfileState createState() => _CardCaseProfileState();
}

class _CardCaseProfileState extends State<CardCaseProfile> {
  TextStyle style = TextStyle(color: Colors.black);

  FirestoreService _firestoreService = FirestoreService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CaseModel caso = widget.caso;
    String phoneNumber = caso.phone;
    if (caso.altPhone != "") phoneNumber += " | " + caso.altPhone;

    String healthStatus = caso.symptomatic ? "Sintomático" : "Assintomático";

    Color healthStatusColor = caso.symptomatic ? mainColor : secondColor;

    String activeStatus = caso.isActive ? "Activo" : "Recuperado";

    Color activeStatusColor = caso.isActive ? mainColor : secondColor;

    String imgGenre =
        caso.genre == "Masculino" ? "urban-user-1.png" : "urban-user-2.png";

    bool isFollower = _auth.currentUser.uid == caso.followedby.id;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, top: 30),
              child: Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  //color: Colors.grey[200],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/${imgGenre}")),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${caso.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      "${caso.address.city}, ${caso.address.county} ,${caso.address.street} "),
                  SizedBox(
                    height: 5,
                  ),
                  Text("${caso.address.reference}"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "$phoneNumber",
              style: style,
            ),
            SizedBox(height: 10),
            Divider(
              height: 2,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "${caso.genre}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.userClock,
                        size: 18,
                        color: mainColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("${caso.age} ${caso.ageType}",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: screenWidth(context) * 0.9,
                decoration: BoxDecoration(
                    color: Color(0xfff4f6f9),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.streetView,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            "Local de isolamento",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35),
                      child: Text("${caso.isolationPlace}"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: activeStatusColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
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
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            enableFeedback: caso.isActive,
                            backgroundColor: healthStatusColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {
                          if (isFollower) {
                            _showMyDialogSymptom(
                                context: context, status: healthStatus);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: mainColor,
                                content:
                                    Text('Não é responsável por esse caso!')));
                          }
                        },
                        child: Text(
                          "$healthStatus",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            )
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
                      id: widget.caso.id,
                      state: 'isActive',
                      value: !widget.caso.isActive,
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
                        id: widget.caso.id,
                        state: 'symptomatic',
                        value: !widget.caso.symptomatic)
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
