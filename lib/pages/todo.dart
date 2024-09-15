import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:remainder_application/pages/homepage.dart';
import 'package:weekly_calendar/weekly_calendar.dart';

import '../service/database.dart';

class todo extends StatefulWidget {
  const todo({super.key});

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {

  late String formatDate;
  TextEditingController todo = new TextEditingController();
  TextEditingController description = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Row(
          children: [
            Text(
              "ToDo",
                style: GoogleFonts.pacifico(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 20.0
                )
            ),
            Text(" Plan",
              style: GoogleFonts.ibmPlexSansArabic(
                  color: Colors.white,
                  fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 20, right: 20),
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
                controller: todo,
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
                controller: description,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20.0)),
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

            Container(
              child: WeeklyCalendar(
                calendarStyle: CalendarStyle(
                  locale: "en_US",
                  margin: EdgeInsets.all(10),
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
                    ]
                  ),
                ),
                isAutoSelect: true,
                onChangedSelectedDate: (date) {
                  formatDate = DateFormat('yyyy-mm-dd').format(date);
                },
              ),
            ), // Displays the weekly calender

            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> todoInfoMap = {
                        "Todo": todo.text,
                        "Description": description.text,
                        "id": id,
                        "date": formatDate
                      };
                      await DatabaseMethods().addTodoDetails(todoInfoMap, id)
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check, color: Colors.white,),
                                              SizedBox(width: 10,),
                                              Text(
                                                "Added Successfully",
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
                                              },
                                              child: Text("Ok")
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            );
                          }
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: Text(
                        "Add",
                        style: GoogleFonts.alice(
                            color: Colors.white
                        ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
