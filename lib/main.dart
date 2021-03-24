import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:firebase_cco2/screens/home.dart';
import 'package:firebase_cco2/screens/sign_in.dart';
import 'package:firebase_cco2/services/shared_prefs_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/helper.dart';

//VERIFICAR SE O EMAIL EXIST

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              initialData: null,
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: createMaterialColor(mainColor),
              fontFamily: 'Montserrat'),
          home: AuthenticationWrapper(),
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return Home();
    }

    return SignIn();
  }
}
