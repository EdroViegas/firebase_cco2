import 'package:firebase_cco2/cards/card_category.dart';
import 'package:firebase_cco2/cards/user_card.dart';
import 'package:firebase_cco2/helpers/dialogues.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/screens/add_case.dart';
import 'package:firebase_cco2/screens/cases.dart';
import 'package:firebase_cco2/screens/cases_asymptomatic.dart';
import 'package:firebase_cco2/screens/cases_recovered.dart';
import 'package:firebase_cco2/screens/cases_symptomatic.dart';
import 'package:firebase_cco2/screens/sign_in.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:firebase_cco2/services/firestore_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  UserModel userLoad = UserModel();

  FirestoreService _firestoreService = FirestoreService();

  /* loadSharedPrefs() async {
    SharedPref sharedPref = SharedPref();
    try {
      print('\n\n\n');
      print(await sharedPref.read("user"));
      print('\n\n\n');

      UserModel user = UserModel.fromData(await sharedPref.read("user"));
      //print(user.toJson());
      return user;
    } catch (Excepetion) {
      // do something
      print("Error retrieving user data in SharedPrefs ");
    }
  }

  */

  @override
  Widget build(BuildContext context) {
    bool isVerified = context.read<AuthenticationService>().isVerifiedUser();

    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.notifications_on_sharp), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SignIn()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              isVerified
                  ? Container()
                  : TextButton.icon(
                      onPressed: () {
                        context.read<AuthenticationService>().reloadUser();
                        setState(() {
                          isVerified = context
                              .read<AuthenticationService>()
                              .isVerifiedUser();
                          if (isVerified)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: mainColor,
                                content:
                                    Text('E-mail verificado com sucesso')));
                          else
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: mainColor,
                                content: Text('E-mail não verificado')));
                        });
                      },
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      icon: FaIcon(FontAwesomeIcons.checkCircle),
                      label: Text(
                        "Confirme o seu e-mail ...",
                        style: TextStyle(color: Colors.red),
                      )),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 400,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder(
                    future: _firestoreService.getUserData(),
                    builder: (ctx, snapshot) {
                      // Checking if future is resolved or not
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar os dados',
                              style: TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final user = snapshot.data as UserModel;

                          return Column(
                            children: [
                              UserCard(
                                  name: user.fullName,
                                  address: user.address,
                                  email: user.email,
                                  phone: user.phone,
                                  altPhone: user.altPhone,
                                  role: user.userRole),
                            ],
                          );
                        }
                      }

                      // Displaying LoadingSpinner to indicate waiting state
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(child: Container()),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    //color: Colors.white,
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVerified) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Cases()));
                        } else {
                          snaCKbar("Confirme o seu e-mail");
                        }
                      },
                      child: CardCaseCategory(
                          isVerified: isVerified,
                          title: "CASOS",
                          image: "assets/images/pale-coronavirus.png",
                          icon: FontAwesomeIcons.viruses,
                          color: mainColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        //fullScreenProcessingDialog(
                        //  context: context, dismissible: true);

                        registerErrorDialogue(
                          hasError: false,
                          isProcessing: false,
                          isWarning: false,
                          message: 'Erro ao cadastrar',
                          context: context,
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          if (isVerified) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SymptomaticCases()));
                          } else {
                            snaCKbar("Confirme o seu e-mail");
                          }
                        },
                        child: CardCaseCategory(
                            isVerified: isVerified,
                            title: "SINTOMÁTICOS",
                            image: "assets/images/fogg-doctor.png",
                            icon: FontAwesomeIcons.procedures),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (isVerified) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AsymptomaticCases()));
                        } else {
                          snaCKbar("Confirme o seu e-mail");
                        }
                      },
                      child: CardCaseCategory(
                          isVerified: isVerified,
                          title: "ASSINTOMÁTICOS",
                          image: "assets/images/fogg-pandemic-set.png",
                          icon: FontAwesomeIcons.shieldVirus,
                          color: secondColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (isVerified) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RecoveredCase()));
                        } else {
                          snaCKbar("Confirme o seu e-mail");
                        }
                      },
                      child: CardCaseCategory(
                          isVerified: isVerified,
                          title: "RECUPERADOS",
                          image: "assets/images/fogg-pandemic-set.png",
                          icon: FontAwesomeIcons.checkCircle,
                          color: secondColor),
                    ),
                    SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isVerified) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddCase()));
          } else {
            snaCKbar("Confirme o seu e-mail");
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _cardCases(
      {String title,
      IconData icon,
      String image,
      Color color,
      bool isVerified}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              FaIcon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "${title}",
                style: TextStyle(
                    color: color, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("$image"), fit: BoxFit.scaleDown),
            ),
          ),
        ],
      ),
    );
  }

  snaCKbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: mainColor, content: Text('$message')));
  }
}
