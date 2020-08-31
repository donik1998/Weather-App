import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:how_is_my_weather/complexUIPart/CloudAnimation.dart';
import 'package:how_is_my_weather/complexUIPart/CustomCircularProgressBar.dart';
import 'package:how_is_my_weather/complexUIPart/RainAnimation.dart';
import 'package:how_is_my_weather/complexUIPart/RotationAnimation.dart';
import 'package:how_is_my_weather/tools/Extensions.dart';
import 'package:how_is_my_weather/tools/Weather.dart';
import 'package:how_is_my_weather/tools/weather_icons_icons.dart';
import 'package:http/http.dart';

class WeatherScreen extends StatefulWidget {
  final Position position;
  Weather weather;

  WeatherScreen({Key key, this.position, this.weather}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  DateTime _now;
  bool _isNight;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      TickerProvider: this,
      value: 0.0,
      upperBound: 1,
      lowerBound: -1,
    )..repeat();
    _now = DateTime.now();
    _isNight = _now.hour >
            widget.weather.convertedDate(widget.weather.sunset).hour ||
        _now.hour < widget.weather.convertedDate(widget.weather.sunrise).hour;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _isNight
              ? Image.asset('assets/images/nightBackImage.png').image
              : Image.asset('assets/images/dayBackImage.png').image,
          fit: BoxFit.cover,
          colorFilter: _isNight
              ? ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.darken)
              : ColorFilter.mode(
                  Colors.blue.withOpacity(0.6), BlendMode.lighten),
        ),
      ),
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
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.weather.city + ', ' + widget.weather.country,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Acme-Regular',
                    fontSize: 30.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.white,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.white,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Temperature',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PathwayGothicOne-Regular',
                    fontSize: 20.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: _isNight
                          ? (widget.weather.temperature.round() - 273) > 0
                              ? Colors.blueGrey.shade900
                              : Colors.blueAccent
                          : (widget.weather.temperature.round() - 273) > 0
                              ? Colors.amberAccent.shade400
                              : Colors.blueAccent.shade700,
                      spreadRadius: 1.0,
                      blurRadius: 5.0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: FAProgressBar(
                  progressColor: Colors.blueAccent.shade700,
                  changeColorValue: 5,
                  changeProgressColor: widget.weather.temperature.round() -
                                  273 <=
                              0 ||
                          (widget.weather.temperature.round() - 273 > 0 &&
                              widget.weather.temperature.round() - 273 <= 10)
                      ? Colors.blueAccent.shade700
                      : widget.weather.temperature.round() - 273 > 10 &&
                              widget.weather.temperature.round() - 273 <= 18
                          ? Colors.greenAccent.shade400
                          : widget.weather.temperature.round() - 273 > 18 &&
                                  widget.weather.temperature.round() - 273 < 25
                              ? Colors.yellow.shade400
                              : Colors.red.shade700,
                  backgroundColor: Colors.transparent,
                  borderRadius: 10.0,
                  maxValue: 100,
                  animatedDuration: Duration(seconds: 2),
                  currentValue: widget.weather.temperature.round() - 273,
                  displayText: '\u2103',
                  size: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Condition',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PathwayGothicOne-Regular',
                    fontSize: 20.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      widget.weather.condition.equals('Clear')
                          ? RotationAnimation(
                              animationDuration: Duration(seconds: 10),
                              child: _isNight
                                  ? Image.asset(
                                      'assets/images/moon.png',
                                      height: 100.0,
                                    )
                                  : Image.asset(
                                      'assets/images/sun.png',
                                      height: 100.0,
                                    ),
                            )
                          : widget.weather.condition.equals('Clouds')
                              ? Container(
                                  height: 100.0,
                                  width: 100.0,
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: <Widget>[
                                      Positioned(
                                        right: 0,
                                        bottom: 30.0,
                                        child: RotationAnimation(
                                          animationDuration:
                                              Duration(seconds: 10),
                                          child: _isNight
                                              ? Image.asset(
                                                  'assets/images/moon.png',
                                                  height: 50.0,
                                                )
                                              : Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 50.0,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        child: CloudAnimation(
                                          clipColor: Colors.white,
                                          clipAnimationController: _controller,
                                          boxSize: Size(100.0, 100.0),
                                          animationDuration:
                                              Duration(seconds: 2),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : widget.weather.condition.equals('Rain')
                                  ? RainAnimation(
                                      controller: _controller,
                                      cloudColor: Colors.grey.shade700,
                                      rainDropColor: Colors.blue,
                                      animationBoxSize: Size(100.0, 100.0),
                                      rainDropSize: Size(50.0, 50.0),
                                      horizontalDropsOffset: 15.0,
                                    )
                                  : widget.weather.condition
                                          .equals('Thunderstorm')
                                      ? Image.asset(
                                          'assets/images/thunderstorm.png')
                                      : widget.weather.condition
                                              .equals('Drizzle')
                                          ? Image.asset(
                                              'assets/images/rain.jpg')
                                          : widget.weather.condition
                                                  .equals('Snow')
                                              ? RotationAnimation(
                                                  animationDuration:
                                                      Duration(seconds: 10),
                                                  child: Image.asset(
                                                    'assets/images/snow.jpg',
                                                    height: 100.0,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/images/other.png',
                                                  height: 100.0,
                                                ),
                      Text(
                        widget.weather.condition,
                        style: TextStyle(
                          color: _isNight ? Colors.white : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomCircleProgressBar(
                          backColor: Colors.transparent,
                          frontColor: Colors.blueAccent.shade400,
                          size: 100.0,
                          indicatorImage: Image(
                            image:
                                Image.asset('assets/images/humidity.png').image,
                            height: 50.0,
                          ),
                          animationDuration: Duration(milliseconds: 500),
                          strokeWidth: 10.0,
                          currentValue: widget.weather.humidity.toDouble(),
                          maxValue: 100.0,
                          initialValue: 0,
                        ),
                      ),
                      Text(
                        widget.weather.humidity.toString() + '%',
                        style: TextStyle(
                          color: _isNight ? Colors.white : Colors.black,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Wind',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PathwayGothicOne-Regular',
                    fontSize: 20.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _isNight
                                ? Image.asset('assets/images/compassNight.png')
                                    .image
                                : Image.asset('assets/images/compassDay.png')
                                    .image,
                          ),
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(
                              widget.weather.windDirection.toDouble() / 360),
                          child: Image(
                            image: Image.asset('assets/images/compassArrow.png')
                                .image,
                            color: Colors.red,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.weather.convertedWindDirection(),
                          style: TextStyle(
                            color: _isNight ? Colors.white : Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 100.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            width: 2.0,
                            color: Colors.white,
                          ),
                        ),
                        child: RotationAnimation(
                          animationDuration: Duration(seconds: 1),
                          child: Image(
                            image: Image.asset('assets/images/windSpeed.png')
                                .image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.weather.windSpeed + ' m/s',
                          style: TextStyle(
                            color: _isNight ? Colors.white : Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Solar Day',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PathwayGothicOne-Regular',
                    fontSize: 20.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          WeatherIcons.sun,
                          size: 100.0,
                          color: _isNight ? Colors.white : Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.weather
                                    .convertedDate(widget.weather.sunrise)
                                    .hour
                                    .toString() +
                                ':' +
                                widget.weather
                                    .convertedDate(widget.weather.sunrise)
                                    .minute
                                    .toString(),
                            style: TextStyle(
                              color: _isNight ? Colors.white : Colors.black,
                              fontFamily: 'Lato-Regular',
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          WeatherIcons.sunrise,
                          size: 100.0,
                          color: _isNight ? Colors.white : Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.weather
                                    .convertedDate(widget.weather.sunset)
                                    .hour
                                    .toString() +
                                ':' +
                                widget.weather
                                    .convertedDate(widget.weather.sunset)
                                    .minute
                                    .toString(),
                            style: TextStyle(
                              color: _isNight ? Colors.white : Colors.black,
                              fontFamily: 'Lato-Regular',
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
