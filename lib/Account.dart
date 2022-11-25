import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'MyApp.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account details'),
      ),
      body: Container(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
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
    );
  }
}
