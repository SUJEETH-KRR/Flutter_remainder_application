//todo page//

import 'Notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'Account.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      // home: AppBar(title: Text('My Todo task'),),
      home: const MyHomePage(title: "MyTodo task"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //creating local notification object
  // late FlutterLocalNotificationsPlugin localNotifications;
  //
  // //initialize the local notification object
  // @override
  //
  // Future _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     channelDescription: "Description",
  //     importance: Importance.max,
  //     priority: Priority.max,
  //   );
  //   // var androidDetails = AndroidNotificationDetails(id: 1, channelName:);
  //
  //   var generalNotificationDetails = new NotificationDetails(android: androidDetails);
  //   await localNotifications.show(0, "harikishore", "yash", generalNotificationDetails);
  // } // used to display notifications
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String description = "";
  late int hr = 0;
  late int min = 0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speakingngf';
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            (documentSnapshot != null)
                                ? (documentSnapshot["todoTitle"])
                                : "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            (documentSnapshot != null)
                                ? ((documentSnapshot["todoDesc"] != null)
                                    ? documentSnapshot["todoDesc"]
                                    : "")
                                : "",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          trailing: Wrap(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    //todos.removeAt(index);
                                    deleteTodo((documentSnapshot != null)
                                        ? (documentSnapshot["todoTitle"])
                                        : "");
                                  });
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  late int hr = selectedTime.hour;
                                  late int min = selectedTime.minute;
                                  NotificationAPI.showNotification(
                                    id: 0,
                                    title: documentSnapshot!["todoTitle"],
                                    body: documentSnapshot!["todoDesc"],
                                  );
                                  FlutterAlarmClock.createAlarm(hr, min,
                                      title: documentSnapshot!["todoTitle"]);
                                  _selectTime(context);
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext) {
                                  //       return AlertDialog(
                                  //         title: Center(
                                  //             child: Text("Set Notification")),
                                  //         actions: [
                                  //           TextButton(
                                  //               onPressed: () {
                                  //                 setState(() {
                                  //                   _selectTime(context);
                                  //                   FlutterAlarmClock
                                  //                       .createAlarm(
                                  //                     hr = (documentSnapshot !=
                                  //                             null)
                                  //                         ? (documentSnapshot[
                                  //                             "hr"])
                                  //                         : "",
                                  //                     min = (documentSnapshot !=
                                  //                             null)
                                  //                         ? (documentSnapshot[
                                  //                             "min"])
                                  //                         : "",
                                  //                   );
                                  //                   NotificationAPI
                                  //                       .showNotification(
                                  //                     id: 0,
                                  //                     title: documentSnapshot![
                                  //                         "todoTitle"],
                                  //                     body: documentSnapshot![
                                  //                         "todoDesc"],
                                  //                   );
                                  //                 });
                                  //                 Navigator.of(context).pop();
                                  //               },
                                  //               child: Text("Notify"))
                                  //         ],
                                  //       );
                                  //     });
                                  // NotificationAPI.showNotification(id: 0, title: documentSnapshot!["todoTitle"], body: documentSnapshot!["todoDesc"], payload: 'ISDB');
                                  // _showNotification();
                                },
                                icon: const Icon(Icons.notifications_active),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ));
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Center(child: const Text("Add List")),
                        content: Container(
                          width: 500,
                          height: 110,
                          child: Column(
                            children: [
                              ListTile(
                                title: TextField(
                                  onChanged: (String value) {
                                    title = value;
                                    title = _text;
                                  },
                                ),
                                leading: AvatarGlow(
                                  animate: _isListening,
                                  // animate: true,
                                  glowColor: Theme.of(context).primaryColor,
                                  endRadius: 12.0,
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: FloatingActionButton(
                                    onPressed: () => _listen(),
                                    child: Icon(_isListening
                                        ? Icons.mic
                                        : Icons.mic_none),
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (String value) {
                                  description = value;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  //todos.add(title);
                                  createToDo();
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Add"))
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                print("wow");
              },
              child: IconButton(
                icon: Icon(Icons.mic),
                onPressed: () {
                  AlertDialog();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 30.0, 30.0, 150.0),
                            child: Text(
                              _text,
                              style: const TextStyle(
                                fontSize: 32.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  elevation: 4,
                  child: IconButton(
                    iconSize: 25,
                    color: Colors.deepOrange,
                    onPressed: () {
                      print("hello");
                    },
                    icon: Icon(Icons.menu_rounded),
                  ),
                ),
                SpeedDialChild(
                  elevation: 4,
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.deepOrange,
                    icon: Icon(Icons.account_circle_sharp),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Account()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
