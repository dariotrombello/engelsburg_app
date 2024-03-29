import 'dart:convert';

OpenWeatherMap openWeatherMapFromJson(String str) =>
    OpenWeatherMap.fromJson(json.decode(str));

String openWeatherMapToJson(OpenWeatherMap data) => json.encode(data.toJson());

class OpenWeatherMap {
  OpenWeatherMap({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final double lat;
  final double lon;
  final String timezone;
  final int timezoneOffset;
  final Current current;
  final List<Hourly> hourly;
  final List<Daily> daily;

  factory OpenWeatherMap.fromJson(Map<String, dynamic> json) => OpenWeatherMap(
        lat: json['lat'].toDouble(),
        lon: json['lon'].toDouble(),
        timezone: json['timezone'],
        timezoneOffset: json['timezone_offset'],
        current: Current.fromJson(json['current']),
        hourly:
            List<Hourly>.from(json['hourly'].map((x) => Hourly.fromJson(x))),
        daily: List<Daily>.from(json['daily'].map((x) => Daily.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
        'current': current.toJson(),
        'hourly': List<dynamic>.from(hourly.map((x) => x.toJson())),
        'daily': List<dynamic>.from(daily.map((x) => x.toJson())),
      };
}

class Current {
  Current({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
    this.windGust,
    this.rain,
    this.snow,
  });

  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final List<Weather> weather;
  final double? windGust;
  final The1H? rain;
  final The1H? snow;

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        dt: json['dt'],
        sunrise: json['sunrise'],
        sunset: json['sunset'],
        temp: json['temp'].toDouble(),
        feelsLike: json['feels_like'].toDouble(),
        pressure: json['pressure'],
        humidity: json['humidity'],
        dewPoint: json['dew_point'].toDouble(),
        uvi: json['uvi'].toDouble(),
        clouds: json['clouds'],
        visibility: json['visibility'],
        windSpeed: json['wind_speed'].toDouble(),
        windDeg: json['wind_deg'],
        weather:
            List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
        windGust: json['wind_gust']?.toDouble(),
        rain: json['rain'] == null ? null : The1H.fromJson(json['rain']),
        snow: json['snow'] == null ? null : The1H.fromJson(json['snow']),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'weather': List<dynamic>.from(weather.map((x) => x.toJson())),
        'wind_gust': windGust,
        'rain': rain?.toJson(),
        'snow': snow?.toJson(),
      };
}

class Hourly {
  Hourly({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
    this.windGust,
    required this.pop,
    this.rain,
    this.snow,
  });

  final int dt;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final List<Weather> weather;
  final double? windGust;
  final double pop;
  final The1H? rain;
  final The1H? snow;

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        dt: json['dt'],
        temp: json['temp'].toDouble(),
        feelsLike: json['feels_like'].toDouble(),
        pressure: json['pressure'],
        humidity: json['humidity'],
        dewPoint: json['dew_point'].toDouble(),
        uvi: json['uvi'].toDouble(),
        clouds: json['clouds'],
        visibility: json['visibility'],
        windSpeed: json['wind_speed'].toDouble(),
        windDeg: json['wind_deg'],
        weather:
            List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
        windGust: json['wind_gust']?.toDouble(),
        pop: json['pop'].toDouble(),
        rain: json['rain'] == null ? null : The1H.fromJson(json['rain']),
        snow: json['snow'] == null ? null : The1H.fromJson(json['snow']),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'weather': List<dynamic>.from(weather.map((x) => x.toJson())),
        'wind_gust': windGust,
        'pop': pop,
        'rain': rain?.toJson(),
        'snow': snow?.toJson(),
      };
}

class The1H {
  The1H({
    required this.the1H,
  });

  final double the1H;

  factory The1H.fromJson(Map<String, dynamic> json) => The1H(
        the1H: json['1h'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '1h': the1H,
      };
}

class Weather {
  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  final int id;
  final String main;
  final String description;
  final String icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}

class Daily {
  Daily({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    this.windGust,
    required this.weather,
    required this.clouds,
    required this.pop,
    this.rain,
    this.snow,
    required this.uvi,
  });

  final int dt;
  final int sunrise;
  final int sunset;
  final int moonrise;
  final int moonset;
  final double moonPhase;
  final Temp temp;
  final FeelsLike feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double windSpeed;
  final int windDeg;
  final double? windGust;
  final List<Weather> weather;
  final int clouds;
  final double pop;
  final double? rain;
  final double? snow;
  final double uvi;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json['dt'],
        sunrise: json['sunrise'],
        sunset: json['sunset'],
        moonrise: json['moonrise'],
        moonset: json['moonset'],
        moonPhase: json['moon_phase'].toDouble(),
        temp: Temp.fromJson(json['temp']),
        feelsLike: FeelsLike.fromJson(json['feels_like']),
        pressure: json['pressure'],
        humidity: json['humidity'],
        dewPoint: json['dew_point'].toDouble(),
        windSpeed: json['wind_speed'].toDouble(),
        windDeg: json['wind_deg'],
        windGust: json['wind_gust']?.toDouble(),
        weather:
            List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
        clouds: json['clouds'],
        pop: json['pop'].toDouble(),
        rain: json['rain']?.toDouble(),
        snow: json['snow']?.toDouble(),
        uvi: json['uvi'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
        'moon_phase': moonPhase,
        'temp': temp.toJson(),
        'feels_like': feelsLike.toJson(),
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'weather': List<dynamic>.from(weather.map((x) => x.toJson())),
        'clouds': clouds,
        'pop': pop,
        'rain': rain,
        'snow': snow,
        'uvi': uvi,
      };
}

class FeelsLike {
  FeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });

  final double day;
  final double night;
  final double eve;
  final double morn;

  factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
        day: json['day'].toDouble(),
        night: json['night'].toDouble(),
        eve: json['eve'].toDouble(),
        morn: json['morn'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'night': night,
        'eve': eve,
        'morn': morn,
      };
}

class Temp {
  Temp({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  final double day;
  final double min;
  final double max;
  final double night;
  final double eve;
  final double morn;

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        day: json['day'].toDouble(),
        min: json['min'].toDouble(),
        max: json['max'].toDouble(),
        night: json['night'].toDouble(),
        eve: json['eve'].toDouble(),
        morn: json['morn'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'min': min,
        'max': max,
        'night': night,
        'eve': eve,
        'morn': morn,
      };
}
