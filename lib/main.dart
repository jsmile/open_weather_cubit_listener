import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_cubit/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';

import 'cubits/theme/theme_cubit.dart';
import 'repositories/weather_repository.dart';

import 'pages/home_page.dart';
import 'services/weather_api_service.dart';

void main() async {
  ansiColorDisabled = false;
  // 환경변수 읽기
  // await dotenv.load(fileName: '.env', isOptional: true);
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiService: WeatherApiService(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(
              weatherCubit: context.read<WeatherCubit>(),
            ),
          )
        ],
        // context 적용 시
        // Error: Could not find the correct Provider<ThemeCubit> 문제 해결을 위해
        // 올바른 context 의 지정이 필요하므로 builder 를 사용해야 하고
        // 이를 위해 BlocBuilder<xxxBloc, xxxState>( builder: (context, state) { ... } ) 적용.
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Flutter BLoC - OpenWeather Cubit',
              debugShowCheckedModeBanner: false,
              theme:
                  // BlocBuilder<>() 가 context.watch<> 역할을 하므로 삭제
                  // context.watch<ThemeCubit>().state.appTheme == AppTheme.light
                  state.appTheme == AppTheme.light
                      ? ThemeData.light()
                      : ThemeData.dark(),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
