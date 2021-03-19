import 'package:firebase_cco2/screens/sign_up.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "User e-mail ",
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20)),
              onPressed: () {
                context.read<AuthenticationService>().loginWithEmail(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim());
              },
              child: Text("Sign In"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SignUp()));
              },
              child: Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
