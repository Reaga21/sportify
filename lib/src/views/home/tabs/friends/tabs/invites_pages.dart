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
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<QueryDocumentSnapshot<Object?>> _items = [];

  String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final myTween = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  );

  Future<List<QueryDocumentSnapshot<Object?>>> getFriendsReq() async {
    return (await users.where("pendingInv", arrayContains: uid).get()).docs;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
        future: getFriendsReq(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot) {
          if (snapshot.hasData) {
            _items = snapshot.data!;
            return AnimatedList(
              key: listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(index, _items[index], animation);
              },
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildItem(int index, QueryDocumentSnapshot<Object?> item,
      Animation<double> animation) {
    return SlideTransition(
        position: animation.drive(myTween),
        child: Card(
            child: ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(base64Decode(item.get("pic"))),
          ),
          title: Text(item.get("name")),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                onPressed: () async {
                  users.doc(item.id).update({
                    'pendingInv': FieldValue.arrayRemove([uid]),
                    'friends': FieldValue.arrayUnion([uid])
                  });
                  users.doc(uid).update({
                    'pendingReq': FieldValue.arrayRemove([item.id]),
                    'friends': FieldValue.arrayUnion([item.id])
                  });
                  _deleteItem(index);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
                onPressed: () async {
                  users.doc(item.id).update({
                    'pendingInv': FieldValue.arrayRemove([uid]),
                  });
                  users.doc(uid).update({
                    'pendingReq': FieldValue.arrayRemove([item.id]),
                  });
                  _deleteItem(index);
                },
              ),
            ],
          ),
        )));
  }

  void _deleteItem(int index) {
    QueryDocumentSnapshot<Object?> removedItem = _items.removeAt(index);
    listKey.currentState!.removeItem(index, (context, animation) {
      return _buildItem(index, removedItem, animation);
    });
  }
}
