import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/views/home/tabs/profile/profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final account = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
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
                    buildTextField("Email", account!.email.toString(), false),
                    buildTextField("Password", "*******", true)
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text("Delete Account")),
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

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
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
            )),
      ),
    );
  }
}
