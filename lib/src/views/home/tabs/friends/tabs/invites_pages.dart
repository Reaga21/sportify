import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InvitesPage extends StatefulWidget {
  const InvitesPage({Key? key}) : super(key: key);

  @override
  State<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<List<QueryDocumentSnapshot<Object?>>> getFriendsReq() async {
    return (await users.where("pendingInv", arrayContains: uid).get()).docs;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: getFriendsReq(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot) {
        List<Widget> tiles = [];
        if (snapshot.hasData) {
          var docs = snapshot.data!;
          for (var doc in docs) {
            tiles.add(
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(doc.get("pic"))),
                ),
                title: Text(doc.get("name")),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    users.doc(doc.id).update({
                      'pendingInv': FieldValue.arrayRemove([uid]),
                      'friends': FieldValue.arrayUnion([uid])
                    });
                    users.doc(uid).update({
                      'pendingFriends': FieldValue.arrayRemove([doc.id]),
                      'friends': FieldValue.arrayUnion([doc.id])
                    });
                  },
                ),
              ),
            );
          }
          return ListView(
            children: tiles,
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
