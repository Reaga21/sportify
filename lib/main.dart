import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/loading/loading_page.dart';
import 'package:sportify/src/views/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final user = FirebaseAuth.instance.currentUser;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StepModel({
            "1970-01-01": {
              "stepsAbs": 0,
              "stepsDay": 0,
            }
          }, "00:00:00 01.01.1970", "Mustermann"),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme(
              primary: Color(0xFF00bb2d),
              primaryVariant: Color(0xFF1c7923),
              secondary: Color(0xFFffffff),
              secondaryVariant: Color(0xFFCECECE),
              surface: Color(0xFF424242),
              background: Color(0xFF3f3d3e),
              error: Color(0xFFbb002c),
              onPrimary: Color(0xFFffffff),
              onSecondary: Color(0xFFffffff),
              onSurface: Color(0xFFffffff),
              onBackground: Color(0xFFffffff),
              onError: Color(0xffffffff),
              brightness: Brightness.dark),
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
            headline3: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            headline4: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        home: user == null ? const MyLogin() : const LoadingPage(),
      ),
    ),
  );
}
