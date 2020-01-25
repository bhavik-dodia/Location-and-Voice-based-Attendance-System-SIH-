import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps/gps.dart';
import 'contactus.dart';
import 'main.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

var _currentDate;
var _markedDateMap;

final db = Firestore.instance;
double dist, lat, long;
List<Placemark> placemark;
String name;

// ignore: camel_case_types
class drawer1 extends StatefulWidget {
  @override
  _drawer1State createState() => _drawer1State();
}

class _drawer1State extends State<drawer1> {
  GpsLatlng latlng;

  String address, link;
  String temp1 = "", temp2 = "", ec1, ec2, l1, l2;
  String gatsby;

  void initGps() async {
    var location = Location();
    bool enabled = await location.serviceEnabled();
    if (enabled == false) enabled = await location.requestService();
    if (enabled == true) {
      final gps = await Gps.currentGps();
      latlng = gps;
      String temp = latlng.toString();
      lat = 0.0;
      long = 0.0;
      int i = 0;
      temp1 = "";
      temp2 = "";
      while (temp[i] != ',') {
        temp1 += temp[i];
        i++;
      }
      i += 2;
      while (i != temp.length) {
        temp2 += temp[i];
        i++;
      }
      lat = double.parse(temp1);
      long = double.parse(temp2);
      if ((lat <= 22.1920831 || lat >= 22.188743) &&
          (long >= 73.1878774 || long <= 73.189520))
        Toast.show("You are in the office premises!!!!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(lat);
      print(long);
    } else
      initGps();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Home Page", style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/abstract_bg.jpg"),
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
            color: Colors.black54, //lightens the image
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.transparent,
                  child: CalendarCarousel<Event>(
                    onDayPressed: (DateTime date, List<Event> events) {
                      this.setState(() => _currentDate = date);
                    },
                    daysTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                    ),
                    thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
                    customDayBuilder: (
                      /// you can provide your own build function to make custom day containers
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                      /// This way you can build custom containers for specific days only, leaving rest as default.

                      // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                      // if (day.day == 15) {
                      //   return Center(
                      //     child: Icon(Icons.local_airport),
                      //   );
                      // } else {
                      //   return null;
                      // }
                    },
                    weekFormat: false,
                    markedDatesMap: _markedDateMap,
                    height: 420.0,
                    selectedDateTime: _currentDate,                    
                    /// null for not rendering any border, true for circular border, false for rectangular border
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 40),),
                MaterialButton(
                  color: Colors.white,
                  minWidth: 200,
                  height: 60,
                  textColor: Colors.lightBlue,
                  child: Text(
                    "Mark Attendance",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  splashColor: Colors.white12,
                  onPressed: () {
                    initGps();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.lightBlue),
                  accountName: Text(
                    "$name\n" + s,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/icon.png")),
                    ),
                  ),
                  accountEmail: null,
                ),
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home, color: Colors.redAccent),
                onTap: () {
                  drawer1();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Grievances Form'),
                leading: Icon(
                  Icons.format_list_bulleted,
                  color: Colors.green,
                ),
                /*onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => grievance()
                    ),
                  );
                },*/
              ),
              ListTile(
                title: Text('History'),
                leading: Icon(
                  Icons.history,
                  color: Colors.orange,
                ),
                /*onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => display()
                    ),
                  );
                },*/
              ),
              ListTile(
                title: Text('Contact Us'),
                leading: Icon(Icons.contacts, color: Colors.blueAccent),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => contactus()),
                  );
                },
              ),
              ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Toast.show("You have successfully Logged Out", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    exit(1);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
