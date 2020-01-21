class WeatherData {
  final MainData mainData;
  final List<WeatherStatus> weather;

  WeatherData({this.mainData, this.weather});

  factory WeatherData.fromJson(Map<String, dynamic> parsedJson) {
    final List list = parsedJson['weather'] as List;
    final List<WeatherStatus> weatherStatusList =
        list.map((i) => WeatherStatus.fromJson(i)).toList();

    return WeatherData(
        mainData: MainData.fromJson(parsedJson['main']),
        weather: weatherStatusList);
  }
}

class WeatherStatus {
  var main;
  var icon;

  WeatherStatus({this.main, this.icon});

  factory WeatherStatus.fromJson(Map<String, dynamic> json) {
    return WeatherStatus(main: json['main'], icon: json['icon']);
  }
}

class MainData {
  var temp;
  var pressure;
  var humidity;
  var tempMin;
  var tempMax;

  MainData(
      {this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  factory MainData.fromJson(Map<String, dynamic> json) {
    return MainData(
        temp: json['temp'],
        pressure: json['pressure'],
        humidity: json['humidity'],
        tempMin: json['temp_min'],
        tempMax: json['temp_max']);
  }
}
