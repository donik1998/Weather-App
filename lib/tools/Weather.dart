class Weather {
  final String city, windSpeed, condition, country;
  final double temperature;
  final int humidity;
  final int windDirection;
  final int sunset;
  final int sunrise;

  const Weather(
      {this.city,
      this.temperature,
      this.humidity,
      this.windSpeed,
      this.windDirection,
      this.sunset,
      this.sunrise,
      this.condition,
      this.country});
  factory Weather.fromJSON(Map<String, dynamic> jsonData) {
    return Weather(
      city: jsonData['name'],
      temperature: jsonData['main']['temp'],
      humidity: jsonData['main']['humidity'],
      windDirection: jsonData['wind']['deg'],
      windSpeed: jsonData['wind']['speed'].toString(),
      sunrise: jsonData['sys']['sunrise'],
      sunset: jsonData['sys']['sunset'],
      condition: jsonData['weather'][0]['main'],
      country: jsonData['sys']['country'],
    );
  }
  String convertedWindDirection() {
    if (this.windDirection >= 0 && this.windDirection <= 23) {
      return 'North';
    } else if (this.windDirection > 23 && this.windDirection <= 67) {
      return 'North-East';
    } else if (this.windDirection > 67 && this.windDirection <= 113) {
      return 'East';
    } else if (this.windDirection > 113 && this.windDirection <= 157) {
      return 'South-East';
    } else if (this.windDirection > 157 && this.windDirection <= 206) {
      return 'South';
    } else if (this.windDirection > 206 && this.windDirection <= 247) {
      return 'South-West';
    } else if (this.windDirection > 247 && this.windDirection <= 293) {
      return 'West';
    } else if (this.windDirection > 293 && this.windDirection <= 337) {
      return 'North-West';
    } else if (this.windDirection > 337 && this.windDirection <= 360) {
      return 'North';
    } else {
      return 'None';
    }
  }

  DateTime convertedDate(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
  }
}
