import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:sportify/src/models/user_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<QueryDocumentSnapshot> friendsSuggestions = [];
  String lastSearch = "";

  getSuggestion(String? text) {
    text ??= lastSearch;
    users
        .where("name", isGreaterThanOrEqualTo: text)
        .where("name", isLessThanOrEqualTo: "$text\uf7ff")
        .get()
        .then((query) {
      friendsSuggestions = [];
      if (text!.isNotEmpty) {
        friendsSuggestions = query.docs.where((doc) => doc.id != uid).toList();
      }
      setState(() => lastSearch = text!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: searchBar(),
            ),
            resultSet(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.search),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: TextField(
              onChanged: getSuggestion,
              maxLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget resultSet() {
    if (friendsSuggestions.isNotEmpty) {
      return Column(
        children: friendsSuggestions
            .map(
              (doc) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: MemoryImage(base64Decode(doc.get("pic"))),
                ),
                title: Text(doc.get("name")),
                trailing: StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) {
                    UserModel user = context.read<UserModel>();
                    bool isInvited = user.pendingInv.contains(doc.id);
                    bool isFriend = user.friends.contains(doc.id);
                    return IconButton(
                      icon: determineIcon(isFriend, isInvited),
                      onPressed: () {
                        users.doc(doc.id).update({
                          'pendingReq': FieldValue.arrayUnion([uid])
                        });
                        users.doc(uid).update({
                          'pendingInv': FieldValue.arrayUnion([doc.id])
                        });
                        getSuggestion(null);
                      },
                    );
                  },
                ),
              ),
            )
            .toList(),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Search for a friend",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      );
    }
  }

  Widget determineIcon(bool isFriend, isInvited) {
    if (isFriend) {
      return const Icon(Icons.check_circle);
    } else if (isInvited) {
      return const Icon(Icons.pending);
    } else {
      return const Icon(Icons.add_circle);
    }
  }
}
