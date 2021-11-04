
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/views/loading/loading_page.dart';
import 'package:sportify/src/views/registration_page.dart';

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
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
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
                  primary: Theme.of(context).backgroundColor),
              onPressed: () {
                loginWithEmail(_emailInput.text, _passInput.text).then(
                      (_) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Registration()));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> loginWithEmail(String email, String pass) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  }
}