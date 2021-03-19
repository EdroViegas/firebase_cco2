import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = context.read<AuthenticationService>().currentUser;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Center(
                child: Text(
                    "Nome: ${_currentUser.fullName} , Email: ${_currentUser.email} Role: ${_currentUser.userRole}  Id: ${_currentUser.id} Phone:  , Phone2: ")),
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20)),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
