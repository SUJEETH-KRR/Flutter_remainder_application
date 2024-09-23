import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:remainder_application/pages/todo.dart';
import 'package:remainder_application/service/database.dart';
import 'package:weekly_calendar/weekly_calendar.dart';
import 'package:remainder_application/pages/edit.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Stream? toDoStream; // Creating a stream object to get the details

  getLoad() async {
    toDoStream = await DatabaseMethods().getTodoDetails();
    setState(() {});
  } // This function is to load the Details using the DB methods

  @override
  void initState() {
    getLoad(); // Passing the Stream data.
    super.initState();
  } // initState is the first function which is called when the app launches.

  Widget allToDoDetails() {
    return StreamBuilder(
      stream: toDoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && snapshot.data.docs.isNotEmpty
            ? ListView.builder(
                // Ternary operator is used to check if any data is present in DB, ListView Widget will be rendered
                itemCount: snapshot.data.docs
                    .length, // First need to check how many data is present
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String id = ds.id;

                  String dbDate = ds["date"];
                  DateTime date = DateFormat('yyyy-MM-dd').parse(dbDate);
                  int day = date.day;
                  int month = date.month;

                  return Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 140.0,
                      margin: EdgeInsets.only(bottom: 15.0),
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(1),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        )
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_rounded),
                                  Text(
                                    "$day/$month",
                                    style: GoogleFonts.padauk(
                                        color: Colors.blueGrey[700],
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.blueGrey[700],
                                    ),
                                  ),
                                  Text(
                                    ds["time"],
                                    style: GoogleFonts.padauk(
                                        color: Colors.blueGrey[700],
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.0),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ds["Todo"],
                                style: GoogleFonts.padauk(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => edit(id: id)));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blueGrey[700],
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ds["Description"],
                                  style: GoogleFonts.padauk(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.info,
                                                  color: Colors.blueGrey[700],
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "Did you completed the task",
                                                  style: GoogleFonts.aBeeZee(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.deepOrange,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.cancel),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "No",
                                                        style:
                                                            GoogleFonts.actor(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.0),
                                                      )
                                                    ],
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    await DatabaseMethods()
                                                        .deleteTodoDetails(id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons
                                                          .thumb_up_alt_rounded),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "Yes",
                                                        style:
                                                            GoogleFonts.actor(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.deepOrange,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ); // This Widget is to display the details Todo details
                })
            : Center(
              child: Container(
                  // margin: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("😎",
                        style: TextStyle(
                            fontSize: 100.0,
                            color: Colors.blueGrey[700]
                        ),
                      ),
                      Text(
                        "No Work To Do",
                        style: GoogleFonts.acme(
                            color: Colors.blueGrey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
            ); // If there is no data in the DB, Empty Container will be rendered
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // For center Alignment
          children: [
            Text("Remainder",
                style: GoogleFonts.pacifico(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 25.0)),
            Text(
              " Application",
              style: GoogleFonts.ibmPlexSansArabic(
                  color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [Expanded(child: allToDoDetails())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[700],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => todo()));
        }, // For Naviating to todo page
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
