import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController userRoleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome Completo ",
                ),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Morada",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "E-mail ",
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextField(
                controller: altPhoneController,
                decoration: InputDecoration(
                  labelText: "Telefone Alt",
                ),
              ),
              TextField(
                controller: userRoleController,
                decoration: InputDecoration(
                  labelText: "CCO",
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
                      fullName: nameController.text.trim(),
                      address: addressController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      altPhone: altPhoneController.text.trim(),
                      userRole: userRoleController.text.trim(),
                      password: passwordController.text.trim());
                },
                child: Text("Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
