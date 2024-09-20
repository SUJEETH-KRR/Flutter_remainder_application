import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:remainder_application/pages/todo.dart';
import 'package:remainder_application/service/database.dart';
import 'package:weekly_calendar/weekly_calendar.dart';

import 'homepage.dart';

class edit extends StatefulWidget {
  final String id; // Parameter to accept the ID

  edit({required this.id});

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  // late String id = id;
  late String formatDate;
  late TextEditingController todoController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
    descriptionController = TextEditingController();
    fetchToDoByID();
  }

  Future fetchToDoByID() async {
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection('ToDo')
          .doc(widget.id)
          .get();
      if (ds.exists) {
        todoController.text = ds["Todo"] ?? '';
        descriptionController.text = ds['Description'] ?? '';
        String dateStr =
            ds['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
        DateTime initialDate = DateFormat('yyyy-MM-dd').parse(dateStr);
        formatDate = dateStr;
      } else {
        return Center(
          child: Container(
            child: Text("No data found"),
          ),
        );
      }
    } catch (e) {
      print("Something happened: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Row(
          children: [
            Text("Edit",
                style: GoogleFonts.pacifico(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0)),
            Text(
              " Details",
              style: GoogleFonts.ibmPlexSansArabic(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is your plan",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),

              SizedBox(
                height: 10.0,
              ),
              // For Space between the content and text field
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ), // Box shadow for the textfield
                  ],
                ),
                child: TextField(
                  controller: todoController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              Container(
                child: Row(
                  children: [
                    Text(
                      "Description",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      " (optional)",
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey),
                    )
                  ],
                ),
              ), // For TextField

              SizedBox(
                height: 10.0,
              ),

              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ), // Box shadow for the textfield
                  ],
                ),
                child: TextField(
                  maxLines: 2,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.all(20.0),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),

              Text(
                "Calender",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),

              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 150.0,
                child: WeeklyCalendar(
                  calendarStyle: CalendarStyle(
                    locale: "en_US",
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 8,
                            offset: Offset(0, 5),
                          )
                        ]),
                  ),
                  isAutoSelect: true,
                  onChangedSelectedDate: (date) {
                    formatDate = DateFormat('yyyy-MM-dd').format(date);
                  },
                ),
              ),

              SizedBox(
                height: 15.0,
              ),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateToDoInfo = {
                          "Todo": todoController.text,
                          "Description": descriptionController.text,
                          "date": formatDate,
                          "id": widget.id
                        };
                        await DatabaseMethods()
                            .updateTodoDetails(widget.id, updateToDoInfo)
                            .then((value) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: Colors.blueGrey[700],
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Updated Successfully",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    homepage()),
                                                        (Route<dynamic>
                                                                Route) =>
                                                            false);
                                                  },
                                                  child: Text("Ok")),
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700]),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => homepage()),
                            (Route<dynamic> Route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
