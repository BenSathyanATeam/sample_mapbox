import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../main.dart';
import 'exception_handler.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['PUBLIC_ACCESS_TOKEN']!;
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '10';
String proximity =
    '${sharedPreferences.getDouble('longitude')}%2C${sharedPreferences.getDouble('latitude')}';

Dio _dio = Dio();

Future getSearchResultsFromQueryUsingMapbox(String query) async {
  String url =
      '$baseUrl/$query.json?limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}