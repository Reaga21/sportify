import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<QueryDocumentSnapshot> friendsSuggestions = [];
  var statusIcon = Icons.add_circle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFdedbed),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
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
                            friendsSuggestions = query.docs
                                .where((doc) => doc.id != uid)
                                .toList();
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
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: ListView(
            children: friendsSuggestions
                .map(
                  (doc) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          MemoryImage(base64Decode(doc.get("pic"))),
                    ),
                    title: Text(doc.get("name")),
                    trailing: StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                        return IconButton(
                          icon: Icon(
                            statusIcon,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            users.doc(doc.id).update({
                              'pendingFriends': FieldValue.arrayUnion([uid])
                            });
                            users.doc(uid).update({
                              'pendingInv': FieldValue.arrayUnion([doc.id])
                            });
                            stateSetter(() => statusIcon = Icons.check_circle);
                          },
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
