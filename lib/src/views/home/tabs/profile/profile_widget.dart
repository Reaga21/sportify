import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/user_model.dart';

class ProfilePicWidget extends StatelessWidget {
  final picker = ImagePicker();
  final users = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  ProfilePicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserModel>();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: Stack(
          children: [
            buildImage(user, Theme.of(context).colorScheme.surface),
            Positioned(bottom: 0, right: 4, child: buildEditIcon(context, user))
          ],
        ),
      ),
    );
  }

  buildImage(UserModel user, Color color) {
    final image = MemoryImage(base64Decode(user.pic));
    return ClipOval(
      child: Material(
        color: color,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Widget buildEditIcon(BuildContext context, UserModel user) {
    return wrapCircle(
        color: Colors.white,
        all: 2,
        child: wrapCircle(
          all: 6,
          color: Theme.of(context).colorScheme.primary,
          child: GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Photo Library'),
                                onTap: () async {
                                  final newImg = await _imgFromGallery();
                                  user.setPic(newImg);
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Camera'),
                              onTap: () async {
                                final newImg = await _imgFromCamera();
                                users.doc(uid).update({"pic": newImg});
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: const Icon(Icons.photo_camera,
                  size: 26, color: Colors.white)),
        ));
  }

  Future<String> _imgFromCamera() async {
    final imageFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 512, maxWidth: 512);
    return _base64img(imageFile!);
  }

  Future<String> _imgFromGallery() async {
    final imageFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 512, maxWidth: 512);
    return _base64img(imageFile!);
  }

  String _base64img(XFile xfile) {
    final bytes = File(xfile.path).readAsBytesSync();
    return base64Encode(bytes);
  }

  Widget wrapCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
