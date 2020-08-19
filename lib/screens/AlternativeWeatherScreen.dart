import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:how_is_my_weather/tools/Weather.dart';
import 'package:http/http.dart';

class MainScreen extends StatefulWidget {
  final Position position;
  Weather weather;

  MainScreen({Key key, this.position, this.weather}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          Response response = await get(
              'https://api.openweathermap.org/data/2.5/weather?lat=${widget.position.latitude}&lon=${widget.position.longitude}&appid=e448d7f38ec1b682815126eeec2b367c');
          if (response.statusCode == 200) {
            setState(() {
              widget.weather = Weather.fromJSON(jsonDecode(response.body));
            });
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.0),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: FlareActor(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
