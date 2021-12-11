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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: searchBar(),
          ),
        ),
        Expanded(
          flex: 6,
          child: resultSet(),
        ),
      ],
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
              onChanged: (text) async {
                users
                    .where("name", isGreaterThanOrEqualTo: text)
                    .where("name", isLessThanOrEqualTo: "$text\uf7ff")
                    .get()
                    .then((query) {
                  friendsSuggestions = [];
                  if (text.isNotEmpty) {
                    friendsSuggestions =
                        query.docs.where((doc) => doc.id != uid).toList();
                  }
                  setState(() {});
                });
              },
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
      return ListView(
        children: friendsSuggestions
            .map(
              (doc) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(doc.get("pic"))),
                ),
                title: Text(doc.get("name")),
                trailing: StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) {
                    UserModel user = context.read<UserModel>();
                    bool alreadyInv = user.pendingInv.contains(doc.id);
                    return IconButton(
                      icon: alreadyInv
                          ? const Icon(
                              Icons.pending,
                              color: Colors.yellow,
                            )
                          : const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                      onPressed: () {
                        users.doc(doc.id).update({
                          'pendingReq': FieldValue.arrayUnion([uid])
                        });
                        users.doc(uid).update({
                          'pendingInv': FieldValue.arrayUnion([doc.id])
                        });
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
        children: const [
          Text("Search for a friend"),
        ],
      );
    }
  }
}
