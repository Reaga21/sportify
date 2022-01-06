import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/views/home/tabs/profile/profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfilePicWidget(),
          const SizedBox(
            height: 24,
          ),
          buildName(context.watch<UserModel>()),
          const SizedBox(
            height: 48,
          ),
          buildEmail(account!),
        ],
      ),
    );
  }

  Widget buildName(UserModel user) =>
      Column(
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
      children: [
        Text(
          user.email.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        )
      ],
    );
  }
}
