import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/views/loading/loading_page.dart';
import 'package:sportify/src/views/registration/registration_page.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  User? user;

  final _emailInput = TextEditingController(text: 'andrea.robitzsch@gmail.com');
  final _passInput = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme
            .of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Text(
          "Login",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      const SizedBox(height: 50),
      SizedBox(
        width: 250,
        child: TextField(
          controller: _emailInput,
          decoration: const InputDecoration(hintText: 'Email'),
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      SizedBox(
        width: 250,
        child: TextField(
          controller: _passInput,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
      ),
      const SizedBox(
        height: 50,
      ),
      ElevatedButton(
        child: const Text('Sign in with Email'),
        style: ElevatedButton.styleFrom(
            primary: Theme
                .of(context)
                .backgroundColor),
        onPressed: () {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _emailInput.text, password: _passInput.text).then(
                (_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoadingPage()));
            },
          ).catchError((error) {
            if(error.code == 'user-not-found'){
              _showDialogNoEmail();
            }else if(error.code == 'wrong-password'){
              _showDialogWrongPassword();
            }
          });
        },
      ),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
        child: const Text('Create an Account'),
        style: ElevatedButton.styleFrom(
            primary: Theme
                .of(context)
                .backgroundColor),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const Registration()));
        },
      ),
        ],
      ),
    ),);
  }
  Future<void> _showDialogNoEmail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email nicht gefunden!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Zur eingegebenen Email Adresse konnte kein Account gefunden werden.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zum Login'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Account anlegen!'),

            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const Registration()));
            },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showDialogWrongPassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Falsches Passwort!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Das eingegebene Passwort ist inkorrekt!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zum Login'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Account anlegen'),

              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const Registration()));
              },
            ),
          ],
        );
      },
    );
  }
}
