import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/views/loading/loading_page.dart';
import 'package:sportify/src/views/registration/registration_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  User? user;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  final Permission _permission = Permission.activityRecognition;

  final _emailInput = TextEditingController(text: 'user@email.com');
  final _passInput = TextEditingController(text: '123456');

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
    if (_permissionStatus != PermissionStatus.granted) {
      requestPermission(_permission);
    }
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: CircleAvatar(
                    radius: 64,
                    backgroundImage: const Image(
                            image: AssetImage('assets/mann_mit_wasser.jpg'))
                        .image),
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
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailInput.text, password: _passInput.text)
                        .then(
                      (_) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoadingPage()));
                      },
                    ).catchError((error) {
                      if (error.code == 'user-not-found') {
                        _showDialogWrongEmPW();
                      } else if (error.code == 'wrong-password') {
                        _showDialogWrongEmPW();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  child: const Text('Create an Account'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Registration()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialogWrongEmPW() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email or Password are wrong!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create an Account'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const Registration()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }
}
