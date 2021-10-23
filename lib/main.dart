import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sportify/src/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightGreen,
        backgroundColor: Colors.green,
      ),
      home: MyLogin(),
    ),
  );
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  User? user;

  final _emailInput = TextEditingController(text: 'klaas.pelzer@gmail.com');
  final _passInput = TextEditingController(text: '123456');

  @override
  void initState() {
    // raus
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() => this.user = user);
    });
  }

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
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 150,
              child: TextField(
                controller: _emailInput,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 150,
              child: TextField(
                controller: _passInput,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
            ),
            SizedBox(
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
                        MaterialPageRoute(builder: (_) => const HomePage()));
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
