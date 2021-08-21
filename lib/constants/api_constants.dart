class ApiConstants {
  static const unauthenticatedEngelsburgApiHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json'
  };
  static const engelsburgApiBaseUrl = 'https://paulhuerkamp.de';
  static const engelsburgApiEventsUrl = engelsburgApiBaseUrl + '/event';
  static const engelsburgApiArticlesUrl = engelsburgApiBaseUrl + '/article';
  static const engelsburgApiCafeteriaUrl = engelsburgApiBaseUrl + '/cafeteria';
  static const engelsburgApiSolarSystemUrl =
      engelsburgApiBaseUrl + '/solar_system';

  static const engelsburgWpJsonBaseUrl =
      'https://engelsburg.smmp.de/wp-json/wp/v2';
  static const engelsburgWpJsonSolarPanelDescriptionUrl =
      engelsburgWpJsonBaseUrl + '/pages/68';
}
