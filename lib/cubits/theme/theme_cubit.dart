import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/constants/constants.dart';
import '/utils/ansi_color.dart';

part 'theme_state.dart';

// Weather 정보를 사용하는 StreamSubscription 을 사용하지 않고
// BlocListener 를 사용하도록 불필요한 정보 제거한 뒤
// 처리가 필요한 정보를 param 으로 사용하는 함수 생성
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  // 현재 온도에 따라 Teheme 을 변경.
  // 필요한 정보를 param 으로 받아서 처리.
  void setTheme(double currentTemp) {
    if (currentTemp > kWarmOrNot) {
      emit(state.copyWith(appTheme: AppTheme.light));
    } else {
      emit(state.copyWith(appTheme: AppTheme.dark));
    }

    debugPrint(info('### Theme State : $state'));
  }
}
