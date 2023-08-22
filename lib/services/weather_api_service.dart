import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../exceptions/weather_exception.dart';
import '../../models/direct_geocoding.dart';
import '../../models/weather.dart';

import '../utils/ansi_color.dart';
import 'http_error_handler.dart';

class WeatherApiService {
  final http.Client httpClient;

  // http 연결을 유지시키기 위해 생성자 함수의 param 으로 받도록 선언
  WeatherApiService({required this.httpClient});

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    // uri 구하기
    final uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        // throw HttpException(httpErrorHandler(response));
        throw httpErrorHandler(response); // 단순히 message 만으로도 throw 가능
      }

      // final responseBody = jsonDecode(response.body);
      final responseBody =
          json.decode(response.body); // 외부 API 에서 받은 json 을 dart 의 map 으로 변환

      if (responseBody.isEmpty) {
        throw WeatherException(message: 'Cannot get the location of $city');
      }

      final directGeocding = DirectGeocoding.fromJson(responseBody);

      return directGeocding;
    } catch (e) {
      rethrow; // 호출한 곳에 error 를 다시 던져줌
    }
  }

  // DirectGeocoding 의 위치를 받아서 해당 위치의 날씨 정보( Weather )를 가져오는 함수
  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    final uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.lon}',
        'units': kTempUnit,
        'appid': dotenv.env['APPID'],
      },
    );

    debugPrint(success('### uri : $uri'));

    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw httpErrorHandler(response); // message 만으로도 throw 가능
      }
      // 외부 API 에서 받은 json 을 dart 의 map 으로 변환
      final responseBody = json.decode(response.body);
      // map 을 Weather model 로 변환
      final Weather weather = Weather.fromMap(responseBody);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
