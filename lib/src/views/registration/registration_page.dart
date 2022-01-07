import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/models/user_model.dart';
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
                    "Registration",
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80.0,
                    child: TextField(
                      controller: bNController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username',
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
                      validator: (value) {
                        if (!(EmailValidator.validate(value!))) {
                          return "Please fill in a valid email address.";
                        }
                        return null;
                      },
                      controller: eMailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email Address',
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
                          hintText: 'Password',
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
                            hintText: 'Confirm Password'),
                        validator: (value) {
                          if (pWController.text != value) {
                            return "The two passwords are not the same.";
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(190, 40),
                    maximumSize: const Size(190, 40),
                  ),
                  child: const Text('Create an Account'),
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
                        stepsDocument.set(
                            StepModel({}, today(), bNController.text).toJson());
                        DocumentReference userDocument = FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(user.user!.uid);
                        userDocument.set(
                            UserModel(bNController.text, pic, [], [], [])
                                .toJson());
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(190, 40),
                    maximumSize: const Size(190, 40),
                  ),
                  child: const Text('Already have an Account'),
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
          title: const Text('Password is too weak!'),
                    actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
          title: const Text('Account already exists!'),
                    actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
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

  String pic =
      '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';
}
