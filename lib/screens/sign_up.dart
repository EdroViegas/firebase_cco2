import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
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
                context.read<AuthenticationService>().signUpWithEmail(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    fullName: "Edro Viegas",
                    role: "admin");
              },
              child: Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
