import 'dart:async';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/models/user_model.dart';
import 'package:sportify/src/views/home/tabs/friends/friends_page.dart';
import 'package:sportify/src/views/home/tabs/profile/profile_page.dart';
import 'package:sportify/src/views/home/tabs/statistics/statistic_page.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/steps_overview.dart';
import 'package:sportify/src/views/login/login_page.dart';

const updateStepsTask = "updateStepsTask";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<StepCount> pedometerStream = Pedometer.stepCountStream;
  late StreamSubscription<User?> _authListener;
  ReceivePort? _receivePort;
  int _counter = 0;
  int selectedIndex = 0;
  List<Widget> _pages = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  void _startForegroundTask() async {
    //only start Service if not already running
    if (!await FlutterForegroundTask.isRunningService) {
      _receivePort = await FlutterForegroundTask.startService(
        notificationTitle: 'Sportify',
        notificationText: 'Counting  steps...',
        callback: startCallback,
      );

      _receivePort?.listen((event) async {
        context.read<StepModel>().updateTodaySteps(event.steps);
        FlutterForegroundTask.updateService(
            notificationText:
                "Today's steps: ${context.read<StepModel>().getTodaySteps()}");
        // only update after 50 new steps counted
        if (_counter > 20) {
          await _updateSteps(context);
          _counter = 0;
        }
        _counter++;
      });
    }
  }

  Future<void> _updateSteps(BuildContext context) async {
    Map<String, dynamic> json = context.read<StepModel>().toJson();
    try {
      await FirebaseFirestore.instance
          .collection('steps')
          .doc(uid)
          .update(json);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
    _startForegroundTask();
    _authListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        FlutterForegroundTask.stopService().then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MyLogin()));
        });
      }
    });
    _pages = <Widget>[
      StepOverviewPage(
        changeTabCallback: changeTab,
      ),
      const FriendsPage(),
      const StatisticPage(),
      const ProfilePage(),
    ];
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000 * 30, //every 30 sec
        autoRunOnBoot: true,
      ),
      printDevLog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel>(
            create: (_) => getUserStream(),
            initialData: UserModel("", "", [], [], []))
      ],
      child: WithForegroundTask(
        child: Scaffold(
          body: IndexedStack(
            children: _pages,
            index: selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: changeTab,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.run_circle),
                label: 'Steps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _receivePort?.close();
    _authListener.cancel();

    super.dispose();
  }

  Stream<UserModel> getUserStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map<UserModel>((snap) {
      return UserModel.fromJson(snap.data() as Map<String, dynamic>);
    });
  }
}

class FirstTaskHandler implements TaskHandler {
  final pedometer = Pedometer.stepCountStream;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    pedometer.listen((event) {
      sendPort?.send(event);
    }).onError((error) =>
        FlutterForegroundTask.updateService(notificationText: '$error'));
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}

  @override
  void onButtonPressed(String id) {}
}

void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}
