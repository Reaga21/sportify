// @dart=2.11
// github_sign_in 0.0.4 is not null safe, 2021-05-18

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Firebase Authentication")),
          body: MyLogin())));
}

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  User user;

  final _emailInput = TextEditingController(text: 'bob@example.com');
  final _passInput = TextEditingController(text: 'secret');

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      setState(() => this.user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SignInButton(Buttons.Email,
            onPressed: () => loginWithEmail(_emailInput.text, _passInput.text)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
              width: 150,
              child: TextField(
                  controller: _emailInput,
                  decoration: InputDecoration(hintText: 'Email'))),
          SizedBox(
              width: 150,
              child: TextField(
                  controller: _passInput,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'))),
        ]),
        Container(child: userInfo()),
        ElevatedButton(
            child: Text('Sign out'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: user != null ? () => logout() : null)
      ],
    ));
  }

  Widget userInfo() {
    if (user == null) return Text('Not signed in.');
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      if (user.photoURL != null) Image.network(user.photoURL, width: 50),
      Text(
          'Signed in as ${user.displayName != null ? user.displayName + ', ' : ''}${user.email}.')
    ]);
  }

  Future<UserCredential> loginWithEmail(String email, String pass) {
    try {
      return FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return Future.value(null);
    }
  }
  logout() => FirebaseAuth.instance.signOut();
}
