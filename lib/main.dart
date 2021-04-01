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
import 'package:responsive_framework/responsive_framework.dart';

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
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              initialData: null,
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges)
        ],
        child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: Container(color: Color(0xFFF5F5F5))),
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
