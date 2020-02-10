import 'dart:convert';

DarkSky darkSkyFromJson(String str) => DarkSky.fromJson(json.decode(str));

class DarkSky {
  final double latitude;
  final double longitude;
  final String timezone;
  final Currently currently;
  final Hourly hourly;
  final Daily daily;
  final int offset;

  DarkSky({
    this.latitude,
    this.longitude,
    this.timezone,
    this.currently,
    this.hourly,
    this.daily,
    this.offset,
  });

  factory DarkSky.fromJson(Map<String, dynamic> json) => DarkSky(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timezone: json["timezone"],
        currently: Currently.fromJson(json["currently"]),
        hourly: Hourly.fromJson(json["hourly"]),
        daily: Daily.fromJson(json["daily"]),
        offset: json["offset"],
      );
}

class Currently {
  final int time;
  final String summary;
  final String icon;
  final double precipIntensity;
  final double precipProbability;
  final String precipType;
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
  final double precipAccumulation;

  Currently({
    this.time,
    this.summary,
    this.icon,
    this.precipIntensity,
    this.precipProbability,
    this.precipType,
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
    this.precipAccumulation,
  });

  factory Currently.fromJson(Map<String, dynamic> json) => Currently(
        time: json["time"],
        summary: json["summary"],
        icon: json["icon"],
        precipIntensity: json["precipIntensity"].toDouble(),
        precipProbability: json["precipProbability"].toDouble(),
        precipType: json["precipType"],
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
        precipAccumulation: json["precipAccumulation"] == null
            ? null
            : json["precipAccumulation"].toDouble(),
      );
}

class Daily {
  final String summary;
  final String icon;
  final List<Datum> data;

  Daily({
    this.summary,
    this.icon,
    this.data,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        summary: json["summary"],
        icon: json["icon"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final int time;
  final String summary;
  final String icon;
  final int sunriseTime;
  final int sunsetTime;
  final double moonPhase;
  final double precipIntensity;
  final double precipIntensityMax;
  final int precipIntensityMaxTime;
  final double precipProbability;
  final String precipType;
  final double temperatureHigh;
  final int temperatureHighTime;
  final double temperatureLow;
  final int temperatureLowTime;
  final double apparentTemperatureHigh;
  final int apparentTemperatureHighTime;
  final double apparentTemperatureLow;
  final int apparentTemperatureLowTime;
  final double dewPoint;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double windGust;
  final int windGustTime;
  final int windBearing;
  final double cloudCover;
  final int uvIndex;
  final int uvIndexTime;
  final double visibility;
  final double ozone;
  final double temperatureMin;
  final int temperatureMinTime;
  final double temperatureMax;
  final int temperatureMaxTime;
  final double apparentTemperatureMin;
  final int apparentTemperatureMinTime;
  final double apparentTemperatureMax;
  final int apparentTemperatureMaxTime;

  Datum({
    this.time,
    this.summary,
    this.icon,
    this.sunriseTime,
    this.sunsetTime,
    this.moonPhase,
    this.precipIntensity,
    this.precipIntensityMax,
    this.precipIntensityMaxTime,
    this.precipProbability,
    this.precipType,
    this.temperatureHigh,
    this.temperatureHighTime,
    this.temperatureLow,
    this.temperatureLowTime,
    this.apparentTemperatureHigh,
    this.apparentTemperatureHighTime,
    this.apparentTemperatureLow,
    this.apparentTemperatureLowTime,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windGust,
    this.windGustTime,
    this.windBearing,
    this.cloudCover,
    this.uvIndex,
    this.uvIndexTime,
    this.visibility,
    this.ozone,
    this.temperatureMin,
    this.temperatureMinTime,
    this.temperatureMax,
    this.temperatureMaxTime,
    this.apparentTemperatureMin,
    this.apparentTemperatureMinTime,
    this.apparentTemperatureMax,
    this.apparentTemperatureMaxTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        time: json["time"],
        summary: json["summary"],
        icon: json["icon"],
        sunriseTime: json["sunriseTime"],
        sunsetTime: json["sunsetTime"],
        moonPhase: json["moonPhase"].toDouble(),
        precipIntensity: json["precipIntensity"].toDouble(),
        precipIntensityMax: json["precipIntensityMax"].toDouble(),
        precipIntensityMaxTime: json["precipIntensityMaxTime"],
        precipProbability: json["precipProbability"].toDouble(),
        precipType: json["precipType"],
        temperatureHigh: json["temperatureHigh"].toDouble(),
        temperatureHighTime: json["temperatureHighTime"],
        temperatureLow: json["temperatureLow"].toDouble(),
        temperatureLowTime: json["temperatureLowTime"],
        apparentTemperatureHigh: json["apparentTemperatureHigh"].toDouble(),
        apparentTemperatureHighTime: json["apparentTemperatureHighTime"],
        apparentTemperatureLow: json["apparentTemperatureLow"].toDouble(),
        apparentTemperatureLowTime: json["apparentTemperatureLowTime"],
        dewPoint: json["dewPoint"].toDouble(),
        humidity: json["humidity"].toDouble(),
        pressure: json["pressure"].toDouble(),
        windSpeed: json["windSpeed"].toDouble(),
        windGust: json["windGust"].toDouble(),
        windGustTime: json["windGustTime"],
        windBearing: json["windBearing"],
        cloudCover: json["cloudCover"].toDouble(),
        uvIndex: json["uvIndex"],
        uvIndexTime: json["uvIndexTime"],
        visibility: json["visibility"].toDouble(),
        ozone: json["ozone"].toDouble(),
        temperatureMin: json["temperatureMin"].toDouble(),
        temperatureMinTime: json["temperatureMinTime"],
        temperatureMax: json["temperatureMax"].toDouble(),
        temperatureMaxTime: json["temperatureMaxTime"],
        apparentTemperatureMin: json["apparentTemperatureMin"].toDouble(),
        apparentTemperatureMinTime: json["apparentTemperatureMinTime"],
        apparentTemperatureMax: json["apparentTemperatureMax"].toDouble(),
        apparentTemperatureMaxTime: json["apparentTemperatureMaxTime"],
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
