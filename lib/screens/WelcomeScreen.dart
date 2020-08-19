import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    child: FlareActor(
                      'assets/flareAnimations/loadingAnimation.flr',
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      animation: 'Untitled',
                    ),
                  ),
                )
              : source == null || position == null
                  ? Center(
                      child: FlatButton(
                        color: Colors.blue.shade400,
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          getData();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 100.0,
                          color: Colors.white,
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
