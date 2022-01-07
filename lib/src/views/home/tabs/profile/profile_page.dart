import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportify/src/views/home/tabs/profile/profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/user_model.dart';
import 'package:sportify/src/views/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailInput = TextEditingController();
  final _passInput = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    final account = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ProfilePicWidget(),
                    const SizedBox(
                      height: 24,
                    ),
                    buildName(context.watch<UserModel>()),
                    const SizedBox(
                      height: 48,
                    ),
                    buildTextField(
                        _emailInput, "Email", account!.email.toString(), false),
                    buildTextField(_passInput, "Password", "*******", true)
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _updateUser, child: const Text("Save"))),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _showDeleteAccount,
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text("Delete Account")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
        ],
      );

  Widget buildEmail(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.email.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        )
      ],
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordTextField,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _updateUser() {
    if (_emailInput.text.isNotEmpty) {
      user.updateEmail(_emailInput.text).then((_) {
        _showToast("Email updated");
        _emailInput.clear();
      }).catchError((error) {
        if (['invalid-email', 'email-already-in-use'].contains(error.code)) {
          _showInvalidEmail();
        } else if (error.code == 'requires-recent-login') {
          _showRelog();
        }
      });
    }
    if (_passInput.text.isNotEmpty) {
      user.updatePassword(_passInput.text).then((_) {
        _showToast("Password updated");
        _passInput.clear();
      }).catchError((error) {
        if (error.code == 'weak-password') {
          _showInvalidPassword();
        } else if (error.code == 'requires-recent-login') {
          _showRelog();
        }
      });
    }
    if (_passInput.text.isEmpty && _emailInput.text.isEmpty) {
      _showToast("No change");
    }
  }

  Future<void> _showDeleteAccount() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you really want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await deleteAccount();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _showInvalidPassword() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password is too weak!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showInvalidEmail() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Email!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRelog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please renew your login'),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Login'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const MyLogin()));
              },
            ),
          ],
        );
      },
    );
  }

  deleteAccount() async {
    await users.doc(user.uid).delete();
    await FirebaseFirestore.instance.collection("steps").doc(user.uid).delete();
    final toDelete = [
      ...(await users.where("pendingInv", arrayContains: user.uid).get()).docs,
      ...(await users.where("pendingReq", arrayContains: user.uid).get()).docs,
      ...(await users.where("friends", arrayContains: user.uid).get()).docs
    ];
    for (final doc in toDelete) {
      deleteUidFromDoc(doc.id);
    }
    user.delete();
  }

  deleteUidFromDoc(String uid) {
    users.doc(uid).update({
      'pendingReq': FieldValue.arrayRemove([user.uid]),
      'pendingInv': FieldValue.arrayRemove([user.uid]),
      'friends': FieldValue.arrayRemove([user.uid])
    });
  }
}
