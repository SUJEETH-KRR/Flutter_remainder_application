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
  late String formatDate, formatTime;
  late String id;
  TextEditingController todoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

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
                fontSize: 20.0,
              ),
            ),
            Text(
              " Plan",
              style: GoogleFonts.ibmPlexSansArabic(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Wrap in SingleChildScrollView
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is your plan",
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              SizedBox(height: 10.0),

              // TextField for todo
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: todoController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 25),

              // Description row
              Row(
                children: [
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  Text(
                    " (optional)",
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              // TextField for description
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  maxLines: 2,
                  controller: descriptionController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 30),

              // Calendar
              Text(
                "Calendar",
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              SizedBox(height: 10.0),

              // WeeklyCalendar
              SizedBox(
                height: 150, // Set a fixed height
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
                        ),
                      ],
                    ),
                  ),
                  isAutoSelect: true,
                  onChangedSelectedDate: (date) {
                    formatDate = DateFormat('yyyy-MM-dd').format(date);
                  },
                ),
              ),
              SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time", style: GoogleFonts.poppins(fontSize: 20),),
                  Text(
                      "${selectedTime.hour > 12
                          ? selectedTime.hour-12
                          :
                      selectedTime.hour}"
                          ":"
                          "${selectedTime.minute} "
                          "${selectedTime.hour > 12 ? "PM" : "AM"}"
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial
                        );
                        if(time != null) {
                          setState(() {
                            selectedTime = time;
                            int hour = selectedTime.hour>12 ? selectedTime.hour-12 : selectedTime.hour;
                            int minute = selectedTime.minute;
                            String am_pm = selectedTime.hour>12 ? "PM" : "AM";
                            formatTime = '${hour.toString()}:${minute.toString()} ${am_pm}';
                          });
                        }
                      },
                      child: Text("Select time"),
                  )
                ],
              ),

              SizedBox(height: 10.0,),

              // Add button
              Container(
                margin: EdgeInsets.all(10),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      id = randomAlphaNumeric(10);
                      Map<String, dynamic> todoInfoMap = {
                        "Todo": todoController.text,
                        "Description": descriptionController.text,
                        "id": id,
                        "date": formatDate,
                        "time": formatTime,
                      };
                      debugPrint(formatDate);
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          "Added Successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => homepage()),
                                                  (Route<dynamic> Route) => false
                                              );
                                            },
                                            child: Text("Ok"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: Text(
                      "Add",
                      style: GoogleFonts.alice(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
