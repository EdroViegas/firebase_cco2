import 'package:firebase_cco2/screens/sign_up.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_cco2/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_cco2/helpers/extensions.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: screenHeight(context) / screenWidth(context),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/crayon-1519.png"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "INICIE A SUA SESSÃO",
                                    style: TextStyle(
                                        color: secondColor, fontSize: 18),
                                  ),
                                  Text("Receba, envie casos e muito mais...",
                                      style: TextStyle(
                                          color: mainColor, fontSize: 16))
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Container(
                                  child: Icon(
                                    Icons.attach_email_outlined,
                                    size: 25,
                                    color: secondColor,
                                  ),
                                ),
                                labelText: "E-mail ",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite o e-mail';
                                }
                                if (!value.isValidEmail())
                                  return 'Digite um e-mail válido';

                                return null;
                              },
                            ),
                            TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Senha",
                                  prefixIcon: Container(
                                    child: Icon(
                                      Icons.vpn_key_outlined,
                                      size: 25,
                                      color: secondColor,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite a sua senha';
                                  }
                                  if (value.length < 8)
                                    return 'Digite senha incorrecta';

                                  return null;
                                }),
                            verticalSpaceMedium,
                            Container(
                              width: screenWidth(context) * 0.9,
                              height: 45,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor: secondColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    context
                                        .read<AuthenticationService>()
                                        .loginWithEmail(
                                            email: email.trim(),
                                            password: password.trim());
                                  }
                                },
                                child: Text("Iniciar sessão",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ),
                            verticalSpaceMedium,
                            Container(
                              width: screenWidth(context) * 0.9,
                              height: 45,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor: mainColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignUp()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Não tem uma conta ?",
                                      style: TextStyle(
                                          color: Color(0xff4920b2),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " Cadastra-se",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
