import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:sportify/src/models/user_model.dart';
import 'package:sportify/main.dart';
import 'package:sportify/src/shared_widgets/step_box.dart';

const updateStepsTask = "updateStepsTask";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Stream<StepCount> pedometerStream = Pedometer.stepCountStream;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late UserModel user;
  ReceivePort? _receivePort;

  void _startForegroundTask() async {
    _receivePort = await FlutterForegroundTask.startService(
      notificationTitle: 'Sportify',
      notificationText: 'Counting  steps...',
      callback: startCallback,
    );

    _receivePort?.listen((event) async {
      user.updateTodaySteps(event.steps, event.timeStamp);
      await _updateSteps();
    });
  }

  Future<void> _updateSteps() async {
    Map<String, dynamic> json = user.toJson();
    try {
      await FirebaseFirestore.instance
          .collection('steps')
          .doc(uid)
          .update(json);
    } catch (error) {
      rethrow;
    }
  }

  Stream<int> _getSteps() async* {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('steps').doc(uid).get();
    user = UserModel.fromJson(snap.data() as Map<String, dynamic>);
    _startForegroundTask();
    yield user.getTodaySteps();
    await for (StepCount _ in pedometerStream) {
      yield user.getTodaySteps();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _initForegroundTask();
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
        interval: 1000 * 10, //every 10th secpr
        autoRunOnBoot: true,
      ),
      printDevLog: true,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await _updateSteps();
    }
  }

  @override
  void dispose() {
    _receivePort?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WithForegroundTask(
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: StreamBuilder<int>(
                    stream: _getSteps(),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasError) {
                        children = <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('Stack trace: ${snapshot.stackTrace}'),
                          ),
                        ];
                      } else {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            children = const <Widget>[
                              Icon(
                                Icons.info,
                                color: Colors.blue,
                                size: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text('Select a lot'),
                              )
                            ];
                            break;
                          case ConnectionState.waiting:
                            children = const <Widget>[
                              SizedBox(
                                child: CircularProgressIndicator(),
                                width: 60,
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text('Awaiting bids...'),
                              )
                            ];
                            break;
                          case ConnectionState.active:
                            children = <Widget>[
                              stepBox(snapshot.data.toString())
                            ];
                            break;
                          case ConnectionState.done:
                            children = <Widget>[
                              stepBox(snapshot.data.toString())
                            ];
                            break;
                        }
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler implements TaskHandler {
  final pedometer = Pedometer.stepCountStream;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    final StepCount event = await pedometer.first;
    sendPort?.send(event);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}
