import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_cubit/constants/constants.dart';

import '../../utils/ansi_color.dart';
import '../weather/weather_cubit.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  // Theme를 처리하기 위해 Weather 정보가 필요함(구독신청을 위해).
  final WeatherCubit weatherCubit;
  late final StreamSubscription weatherSubscription;

  ThemeCubit({
    required this.weatherCubit,
  }) : super(ThemeState.initial()) {
    weatherSubscription =
        // WeatherState 를 listen 하고 있다가
        weatherCubit.stream.listen((WeatherState weatherState) {
      debugPrint(info('### weatherState : $weatherState'));

      if (weatherState.weather.temp > kWarmOrNot) {
        emit(state.copyWith(appTheme: AppTheme.light));
      } else {
        emit(state.copyWith(appTheme: AppTheme.dark));
      }
    });
  }

  @override
  Future<void> close() {
    weatherSubscription.cancel();
    return super.close();
  }
}
