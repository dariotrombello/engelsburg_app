import 'dart:convert';

DarkSky darkSkyFromJson(String str) => DarkSky.fromJson(json.decode(str));

class DarkSky {
  final double latitude;
  final double longitude;
  final String timezone;
  final Currently currently;
  final Hourly hourly;
  final int offset;

  DarkSky({
    this.latitude,
    this.longitude,
    this.timezone,
    this.currently,
    this.hourly,
    this.offset,
  });

  factory DarkSky.fromJson(Map<String, dynamic> json) => DarkSky(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timezone: json["timezone"],
        currently: Currently.fromJson(json["currently"]),
        hourly: Hourly.fromJson(json["hourly"]),
        offset: json["offset"],
      );
}

class Currently {
  final int time;
  final String summary;
  final String icon;
  final double precipIntensity;
  final double precipProbability;
  final double temperature;
  final double apparentTemperature;
  final double dewPoint;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double windGust;
  final int windBearing;
  final double cloudCover;
  final int uvIndex;
  final double visibility;
  final double ozone;
  final String precipType;

  Currently({
    this.time,
    this.summary,
    this.icon,
    this.precipIntensity,
    this.precipProbability,
    this.temperature,
    this.apparentTemperature,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windGust,
    this.windBearing,
    this.cloudCover,
    this.uvIndex,
    this.visibility,
    this.ozone,
    this.precipType,
  });

  factory Currently.fromJson(Map<String, dynamic> json) => Currently(
        time: json["time"],
        summary: json["summary"],
        icon: json["icon"],
        precipIntensity: json["precipIntensity"].toDouble(),
        precipProbability: json["precipProbability"].toDouble(),
        temperature: json["temperature"].toDouble(),
        apparentTemperature: json["apparentTemperature"].toDouble(),
        dewPoint: json["dewPoint"].toDouble(),
        humidity: json["humidity"].toDouble(),
        pressure: json["pressure"].toDouble(),
        windSpeed: json["windSpeed"].toDouble(),
        windGust: json["windGust"].toDouble(),
        windBearing: json["windBearing"],
        cloudCover: json["cloudCover"].toDouble(),
        uvIndex: json["uvIndex"],
        visibility: json["visibility"].toDouble(),
        ozone: json["ozone"].toDouble(),
        precipType: json["precipType"] == null ? null : json["precipType"],
      );
}

class Hourly {
  final String summary;
  final String icon;
  final List<Currently> data;

  Hourly({
    this.summary,
    this.icon,
    this.data,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        summary: json["summary"],
        icon: json["icon"],
        data: List<Currently>.from(
            json["data"].map((x) => Currently.fromJson(x))),
      );
}