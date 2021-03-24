import 'package:firebase_cco2/cards/user_card.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/screens/add_case.dart';
import 'package:firebase_cco2/screens/cases.dart';
import 'package:firebase_cco2/services/authentication_service.dart';
import 'package:firebase_cco2/services/shared_prefs_service.dart';
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

  loadSharedPrefs() async {
    SharedPref sharedPref = SharedPref();
    try {
      UserModel user = UserModel.fromData(await sharedPref.read("user"));
      //print(user.toJson());
      return user;
    } catch (Excepetion) {
      // do something
      print("Error retrieving user data in SharedPrefs ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.notifications_on_sharp), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 350,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder(
                    future: loadSharedPrefs(),
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
                          print("ADDRESS DATA IS : ${user.address}");
                          return UserCard(
                              name: user.fullName,
                              address: user.address,
                              email: user.email,
                              phone: user.phone,
                              altPhone: user.altPhone,
                              role: user.userRole);
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Cases()));
                      },
                      child: _cardCases(
                          title: "CASOS",
                          image: "assets/images/pale-coronavirus.png",
                          icon: FontAwesomeIcons.viruses,
                          color: mainColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _cardCases(
                        title: "SINTOMÁTICOS",
                        image: "assets/images/fogg-doctor.png",
                        icon: FontAwesomeIcons.procedures),
                    SizedBox(
                      height: 15,
                    ),
                    _cardCases(
                        title: "ASSINTOMÁTICOS",
                        image: "assets/images/fogg-pandemic-set.png",
                        icon: FontAwesomeIcons.shieldVirus,
                        color: secondColor),
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AddCase()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _cardCases({String title, IconData icon, String image, Color color}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
}
