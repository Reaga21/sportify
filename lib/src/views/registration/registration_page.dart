import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/util/dates.dart';
import 'package:sportify/src/views/loading/loading_page.dart';
import 'package:sportify/src/views/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController bNController = TextEditingController();
  final TextEditingController eMailController = TextEditingController();
  final TextEditingController pWController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Registrierung",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Leg einen Account an",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80.0,
                    child: TextField(
                      controller: bNController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Benutzername', helperText: ' '),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80.0,
                    child: TextFormField(
                      validator: (value) {
                        if (!(EmailValidator.validate(value!))) {
                          return "Bitte gib eine gültige Email-Adresse ein.";
                        }
                        return null;
                      },
                      controller: eMailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email Adresse',
                          helperText: ' '),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80.0,
                    child: TextFormField(
                      controller: pWController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Passwort',
                          helperText: ' '),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80.0,
                    child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            errorMaxLines: 3,
                            border: OutlineInputBorder(),
                            hintText: 'Passwort bestätigen'),
                        validator: (value) {
                          if (pWController.text != value) {
                            return "Die beiden Passwörter sind ungleich";
                          }
                          return null;
                        }),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                  child: const Text('Registrieren'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondaryVariant),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: eMailController.text,
                              password: pWController.text)
                          .then((user) {
                        DocumentReference stepsDocument = FirebaseFirestore
                            .instance
                            .collection('steps')
                            .doc(user.user!
                                .uid); // Verbindung zur Firebase Collection steps
                        stepsDocument.set(StepModel({}, today(), bNController.text).toJson());
                        DocumentReference userDocument = FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(user.user!.uid);
                        Map<String, dynamic> userModel = {
                          'friends': [],
                          'name': bNController.text,
                          'pendingInv': [],
                          'pendingReq': [],
                          'pic': ''
                        };
                        userDocument.set(userModel);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoadingPage()));
                      }).catchError((error) {
                        if (error.code == 'email-already-in-use') {
                          _showDialogEmailIU();
                        } else if (error.code == 'weak-password') {
                          _showDialogWeakPW();
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  child: const Text('Account bereits vorhanden'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondaryVariant),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const MyLogin()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialogWeakPW() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Passwort zu schwach!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Das eingegebene Passwort ist zu schwach!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zurück zur Registrierung'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogEmailIU() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account bereits vorhanden!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Es gibt bereits einen Account mit dieser Email Adresse!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zur Registrierung'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Zum Login'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const MyLogin()));
              },
            ),
          ],
        );
      },
    );
  }
}
