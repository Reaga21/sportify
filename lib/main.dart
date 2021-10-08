
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sportify/src/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text("Firebase Authentication")),
          body: MyLogin())));
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late User? user;

  final _emailInput = TextEditingController(text: 'bob@example.com');
  final _passInput = TextEditingController(text: 'secret');

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() => this.user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SignInButton(
          Buttons.Email,
          onPressed: () {
            loginWithEmail(_emailInput.text, _passInput.text).then((_) =>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage())));
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
              width: 150,
              child: TextField(
                  controller: _emailInput,
                  decoration: const InputDecoration(hintText: 'Email'))),
          SizedBox(
              width: 150,
              child: TextField(
                  controller: _passInput,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'))),
        ]),
        Container(child: userInfo()),
        ElevatedButton(
            child: const Text('Sign out'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: user != null ? () => logout() : null)
      ],
    ));
  }

  Widget userInfo() {
    if (user == null) return const Text('Not signed in.');
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      if (user!.photoURL != null) Image.network(user!.photoURL ?? '', width: 50),
      Text(
          'Signed in as ${user!.displayName != null ? user!.displayName! + ', ' : ''}${user!.email}.')
    ]);
  }

  Future<UserCredential> loginWithEmail(String email, String pass) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  }

  logout() => FirebaseAuth.instance.signOut();
}
