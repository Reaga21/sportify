import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sportify/main.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/home/tabs/friends/friends_page.dart';
import 'package:sportify/src/views/home/tabs/statistics/statistic_page.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/steps_overview.dart';
import 'package:sportify/src/views/login_page.dart';

const updateStepsTask = "updateStepsTask";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<StepCount> pedometerStream = Pedometer.stepCountStream;
  ReceivePort? _receivePort;
  int _counter = 0;
  int _selectedIndex = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  void _startForegroundTask() async {
    _receivePort = await FlutterForegroundTask.startService(
      notificationTitle: 'Sportify',
      notificationText: 'Counting  steps...',
      callback: startCallback,
    );

    _receivePort?.listen((event) async {
      context.read<StepModel>().updateTodaySteps(event.steps);
      // only update after 50 new steps counted
      if (_counter > 50) {
        await _updateSteps(context);
        _counter = 0;
      }
      _counter++;
    });
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
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: const AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: NotificationIconData(
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
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sportify"),
          backgroundColor: Colors.redAccent,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) =>
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MyLogin())));
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _pages[_selectedIndex],
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) => setState(() {
            _selectedIndex = index;
          }),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _receivePort?.close();
    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    StepOverviewPage(),
    FriendsPage(),
    StatisticPage(),
  ];
}

class FirstTaskHandler implements TaskHandler {
  final pedometer = Pedometer.stepCountStream;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    pedometer.listen((event) {
      FlutterForegroundTask.updateService(notificationText: '$event');
      sendPort?.send(event);
    }).onError((error) =>
        FlutterForegroundTask.updateService(notificationText: '$error'));
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}

void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}
