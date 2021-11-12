import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StepModel({
            "1970-01-01": {
              "stepsAbs": 0,
              "stepsDay": 0,
            }
          }, "00:00:00 01.01.1970"),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightGreen,
          backgroundColor: Colors.green,
        ),
        home: const MyLogin(),
      ),
    ),
  );
}


