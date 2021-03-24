import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cco2/models/address.dart';
import 'package:firebase_cco2/models/case_model.dart';
import 'package:firebase_cco2/models/case_role.dart';
import 'package:firebase_cco2/models/creator_role.dart';
import 'package:firebase_cco2/models/user_model.dart';
import 'package:firebase_cco2/services/shared_prefs_service.dart';
import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AddCase extends StatefulWidget {
  @override
  _AddCaseState createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {
// Initialize form index and FocusNodes

//Start Form Variables
  bool isActive = true;
  bool isSymptomatic = true;
  var _selectedGenre = 0;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _altPhoneController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _countyController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _isolationPlaceController = TextEditingController();

  DateTime activeSince = DateTime.now();

  //Getters

  String get name => _nameController.text;
  String get age => _ageController.text;
  String get phone => _phoneController.text;
  String get altPhone => _altPhoneController.text;
  String get province => _provinceController.text;
  String get county => _countyController.text;
  String get street => _streetController.text;
  String get reference => _referenceController.text;
  String get isolationPlace => _isolationPlaceController.text;

  //End Form Variables

  var _formIndex = 0;
  final _nameFocusNode = FocusNode();
  final _provinceFocusNode = FocusNode();

//FORM KEYS
  final _firstFormKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();
  final _thirdFormKey = GlobalKey<FormState>();

// Dispose FocusNodes when not needed anymore

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _provinceFocusNode.dispose();
    super.dispose();
  }

// Update the _formIndex when switching to another TextFormField
// Give Focus to the other TextFormField
  void switchInputFields(int newIndex) {
    setState(() {
      _formIndex = newIndex;
    });
    newIndex == 0
        ? FocusScope.of(context).requestFocus(_nameFocusNode)
        : FocusScope.of(context).requestFocus(_provinceFocusNode);
  }
// Pass the current _formIndex to the IndexedStack

  void selectGenre(int genre) {
    setState(() {
      _selectedGenre = genre;
    });
  }

  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);

    return n != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: secondColor,
        child: IndexedStack(
          index: _formIndex,
          children: <Widget>[
            _firstForm(),
            _secondForm(),
            _thirdForm(),
          ],
          alignment: Alignment.topRight,
        ),
      ),
    );
  }

  Widget _firstForm() {
    return Form(
      key: _firstFormKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dados Pessoais",
                                style: TextStyle(
                                    color: secondColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Informe os dados pessoais do caso")
                            ],
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.fingerprint,
                          size: 30,
                          color: secondColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nome",
                    ),
                    focusNode: _nameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customRadio(
                          title: "Masculino",
                          icon: FontAwesomeIcons.male,
                          value: 1),
                      _customRadio(
                          title: "Femenino",
                          icon: FontAwesomeIcons.female,
                          value: 2),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Idade",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty || !isNumber(value)) {
                        return 'Digite a idade';
                      }

                      final n = num.tryParse(value);
                      if (n >= 140) return "Idade inválida";
                      return null;
                    },
                  ),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        MaskedInputFormatter(' ### ### ###'),
                      ],
                      decoration: InputDecoration(
                        labelText: "Telefone",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o telefone';
                        }

                        if (value.length != 12) {
                          return 'Digite correctamente o  Nº de telefone';
                        }

                        return null;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Telfone Alternativo",
                      ),
                      inputFormatters: [MaskedInputFormatter(' ### ### ###')],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o telefone alternativo';
                        }

                        if (value.length != 12) {
                          return 'Digite correctamente o  Nº de telefone';
                        }

                        return null;
                      }),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            switchInputFields(_formIndex - 1);
                          },
                          child: Text(
                            "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_firstFormKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              if (_selectedGenre == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: mainColor,
                                        content: Text('Escolha o gênero')));
                              } else {
                                switchInputFields(_formIndex + 1);
                              }
                            }
                          },
                          child: Text(
                            "Próximo",
                            style: TextStyle(
                              color: secondColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondForm() {
    return Form(
      key: _secondFormKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Endereço",
                                style: TextStyle(
                                    color: secondColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Dados necessários para localização")
                            ],
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.mapMarkerAlt,
                          size: 30,
                          color: secondColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextFormField(
                      focusNode: _provinceFocusNode,
                      decoration: InputDecoration(
                        labelText: "Província",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a província';
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Município",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o município';
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Rua",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a rua';
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Referência",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite alguma referência';
                        }
                        return null;
                      }),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            switchInputFields(_formIndex - 1);
                          },
                          child: Text(
                            "Anterior",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_secondFormKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              switchInputFields(_formIndex + 1);
                            }
                          },
                          child: Text(
                            "Próximo",
                            style: TextStyle(
                              color: secondColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _thirdForm() {
    return Form(
      key: _thirdFormKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Estado de saúde",
                                style: TextStyle(
                                    color: secondColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Dados necessários para localização")
                            ],
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.mapMarkerAlt,
                          size: 30,
                          color: secondColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: FlutterSwitch(
                          activeText: "Activo",
                          inactiveText: "Recuperado",
                          activeColor: mainColor,
                          inactiveColor: secondColor,
                          activeIcon: Icon(
                            FontAwesomeIcons.viruses,
                            color: Colors.white,
                          ),
                          activeToggleColor: mainColor,
                          inactiveIcon: Icon(
                            FontAwesomeIcons.shieldVirus,
                            color: Colors.white,
                          ),
                          inactiveToggleColor: secondColor,
                          width: 160.0,
                          height: 35.0,
                          valueFontSize: 16.0,
                          toggleSize: 45.0,
                          value: isActive,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              isActive = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        child: FlutterSwitch(
                          activeText: "Sintomático",
                          inactiveText: "Assintomático",
                          activeColor: mainColor,
                          inactiveColor: secondColor,
                          activeIcon: Icon(
                            FontAwesomeIcons.procedures,
                            color: Colors.white,
                          ),
                          activeToggleColor: mainColor,
                          inactiveIcon: Icon(
                            FontAwesomeIcons.heartbeat,
                            color: Colors.white,
                          ),
                          inactiveToggleColor: secondColor,
                          width: 170.0,
                          height: 35.0,
                          valueFontSize: 16.0,
                          toggleSize: 45.0,
                          value: isSymptomatic,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              isSymptomatic = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Activo desde',
                    timeLabelText: "Horas",
                    selectableDayPredicate: (date) {
                      //Permite excluir datas , no caso todos sabados e domingos
                      // Disable weekend days to select from the calendar
                      //if (date.weekday == 6 || date.weekday == 7) {
                      //return false;
                      //}

                      return true;
                    },
                    onChanged: (val) {
                      activeSince = DateTime.parse(val);
                    },
                    validator: (val) {
                      print(val);

                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: "Local de isolamento",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o local de isolamento';
                        }
                        return null;
                      }),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            switchInputFields(_formIndex - 1);
                          },
                          child: Text(
                            "Anterior",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: secondColor,
                              padding: EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () async {
                            //Validar

                            Timestamp currentTimeStamp =
                                Timestamp.fromDate(DateTime.now());

                            Timestamp timeStamp =
                                Timestamp.fromDate(activeSince);

                            SharedPref sharedPrefs = SharedPref();
                            var data = await sharedPrefs.read('user');

                            UserModel user = UserModel.fromData(data);

                            print(" USER DATA: ${user.fullName}");
                            print("ACTIVO DESDE DATE : ${timeStamp.toDate()}");

                            String genre =
                                _selectedGenre == 1 ? "Masculino" : "Femenino";

                            Address address = Address(
                                city: province,
                                county: county,
                                street: street,
                                reference: reference);
                            CreatorRole creator = CreatorRole(
                                user: user,
                                creatorID: user.id,
                                createdAt: currentTimeStamp);

                            CaseRole role = CaseRole(creatorRole: creator);

                            CaseModel caseModel = CaseModel(
                                name: name,
                                age: age,
                                genre: genre,
                                address: address,
                                isActive: isActive,
                                activeSince: timeStamp,
                                isolationPlace: isolationPlace,
                                phone: phone,
                                altPhone: altPhone,
                                caseRole: role);

                            print(
                                " \n \n USER DATA: ${caseModel.toJson()} \n \n");

                            if (_thirdFormKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                            }
                          },
                          child: Text(
                            "Salvar",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customRadio({String title, IconData icon, int value}) {
    bool isSelected = value == _selectedGenre;
    return InkWell(
      onTap: () {
        selectGenre(value);
      },
      child: Chip(
        backgroundColor: isSelected ? mainColor : Colors.grey[100],
        label: Row(
          children: [
            FaIcon(
              icon,
              color: !(isSelected) ? secondColor : Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "$title",
              style: TextStyle(
                color: !(isSelected) ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
