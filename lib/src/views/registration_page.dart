import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sportify/src/views/home/home_page.dart';
import 'package:sportify/src/views/login_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme.of(context).backgroundColor,
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
                        color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).primaryColor,
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
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 50.0,
                      child: TextField(
                        controller: bNController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),

                            hintText: 'Benutzername'),
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
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 50.0,
                      child: TextFormField(validator: (value) {
                        if(value!.isEmpty){
                          return 'Bitte gib eine gültige Email-Adresse ein.';
                        }
                        return null;

                      } ,
                        controller: eMailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email Adresse'),
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
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 50.0,
                      child: TextField(
                        controller: pWController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Passwort'),
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
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 50.0,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          errorMaxLines: 3,
                            border: OutlineInputBorder(),
                            hintText: 'Passwort bestätigen'
                        ),
                        validator: (value){
                          if(pWController.text != value)
                            {return "Die beiden Passwörter sind ungleich";
                            }
                          return null;
                        }
                      ),
                    ),
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
                  child: const Text('Registrieren'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).backgroundColor),
                  onPressed: () {
                   if (_formKey.currentState!.validate()) {

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const HomePage()));
                      }
                   },
                    ),
                ],
              ),
            ],

        ),
      ),
    );
  }
}


