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
                        FirebaseFirestore.instance
                            .collection('users')
                            .where("name", isGreaterThanOrEqualTo: text)
                            .where("name", isLessThanOrEqualTo: "$text\uf7ff")
                            .get()
                            .then((query) {
                          friendsSuggestions = [];
                          if (text.isNotEmpty) {
                            friendsSuggestions = query.docs;
                            print(friendsSuggestions);
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
                .map((doc) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            MemoryImage(base64Decode(doc.get("pic"))),
                      ),
                      title: Text(doc.get("name")),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(doc.id)
                              .update({
                            'pendingFriends': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid])
                          });
                        },
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
