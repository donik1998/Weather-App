import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:how_is_my_weather/screens/WeatherScreen.dart';
import 'package:how_is_my_weather/tools/Weather.dart';
import 'package:http/http.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Position position;
  Map<String, dynamic> source;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Response response = await get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=e448d7f38ec1b682815126eeec2b367c');
    if (response.statusCode == 200) {
      source = jsonDecode(response.body);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'How is my weather Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.blueAccent.shade400,
          child: position == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Something went wrong\nTry to refresh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(10.0),
                        elevation: 10.0,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        splashColor: Colors.black,
                        color: Colors.cyan.shade500,
                        onPressed: () {
                          getData();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 50.0,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                )
              : source == null
                  ? Center(
                      child: MaterialButton(
                        padding: EdgeInsets.all(10.0),
                        elevation: 10.0,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        splashColor: Colors.black,
                        color: Colors.cyan.shade500,
                        onPressed: () async {
                          getData();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 50.0,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    )
                  : WeatherScreen(
                      position: position,
                      weather: Weather.fromJSON(source),
                    ),
        ),
      ),
    );
  }
}
